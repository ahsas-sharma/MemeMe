//
//  ControllerUtils.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 01/07/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit
import AVFoundation


class ControllerUtils {

    
    /// Handles the visibility of view for empty data set
    ///
    /// - Parameters:
    ///   - view: EmptyDataSetView
    ///   - superview: Superview to which EmptyDataSetView should be added
    ///   - memeCount: Count of stored memes that acts as condition to toggle view's visibility
    static func toggleEmptyDataSetView(_ view: EmptyDataSetView, superview: UIView, memeCount: Int) {
        if memeCount > 0 {
            view.isHidden = true
            superview.sendSubview(toBack: view)
        } else {
            view.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                view.isHidden = false
                view.alpha = 1
                view.bulletImageView.isHidden = true
                superview.bringSubview(toFront: view)
            })
        }
    }
    
    
    /// Handles the presentation of MemeEditorViewController from different screens
    ///
    /// - Parameters:
    ///   - fromStoryboard: Storyboard to be used to initialize the meme editor
    ///   - presentor: The presenting UITabBarController
    ///   - withMeme: If this argument is passed, load up the editor with this meme
    static func presentMemeEditorViewController(fromStoryboard: UIStoryboard, presentor: UITabBarController, withMeme: Meme?) {
        let memeEditorNavigationController = fromStoryboard.instantiateViewController(withIdentifier: "MemeEditorNavigationController") as! UINavigationController
        if withMeme != nil {
            let memeEditorVC = memeEditorNavigationController.viewControllers.first as! MemeEditorViewController
            memeEditorVC.memeToEdit = withMeme
        }
        presentor.present(memeEditorNavigationController, animated: true, completion: nil)
        
    }
    
    
    /// Handles the presentation of MemeDetailViewController from different screens
    ///
    /// - Parameters:
    ///   - fromStoryboard: Storyboard to be used to initialize the meme editor
    ///   - presentor: The presenting NavigationController
    ///   - withMeme: Meme object to show in detail view
    static func pushMemeDetailViewController(fromStoryboard: UIStoryboard, presentor: UINavigationController, withMeme: Meme) {
        let memeDetailVC = fromStoryboard.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = withMeme
        presentor.pushViewController(memeDetailVC, animated: true)
    }
    
    
    typealias saveHandler = ()  -> Void
    
    /// Handles the presentation of ActivityViewController to allow user to share the meme object
    ///
    /// - Parameters:
    ///   - memeImage: memeImage property of the Meme to share
    ///   - presentor: Presenting object that could be TabBarController or MemeEditorViewController
    ///   - sourceView: The view containing the anchor rectangle for the popover. Added to fix crashes on iPad.
    ///   - createNew: If true, call the saveHandler to create a new Meme object
    ///   - saveHandler: Save function that creates a new Meme and appends to memes array
    static func presentShareActivityControllerWithOptions(memeImage: UIImage, presentor: Any, sourceView: UIView, createNew: Bool, saveHandler: saveHandler?) {
        
        var presentingController = presentor as! UIViewController
        
        // Create the activity view controller with activityItems
        let imageToShare = [memeImage]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        // If function was called with createNew as true, set presenting controller to MemeEditorViewController else UITabBarController (for share cell swipe action )
        if createNew {
            presentingController = presentor as! MemeEditorViewController
        } else {
            presentingController = presentor as! UITabBarController
        }
        
        // Fix for crashes on iPad
        activityViewController.popoverPresentationController?.sourceView = sourceView
        
        activityViewController.completionWithItemsHandler =
            { (activityType, completed, returnedItems, error) in
                
                if error != nil {
                    // Just debug print for now. Can better handle error through an alert with retry action.
                    debugPrint("There was an error!")
                } else {
                    
                    // Handle successfully completed activity
                    if completed {
                        
                        // If a new meme needs to be created, call the saveHandler
                        if createNew {
                            saveHandler!()
                        } else {
                
                            // If share action was initiated from swipe cell action of UITableViewCell(from SentMemesListViewController), hide the swipe actions
                            if let sentMemesListVC = ((presentingController as! UITabBarController).selectedViewController as? UINavigationController)?.viewControllers.first as? SentMemesListViewController{
                                sentMemesListVC.tableView.setEditing(false, animated: true)
                            } else {
                                // hide action sheet from collectionview
                            }
                        }
                        
                        // If user selects 'Save Image', display a success message
                        if activityType == UIActivityType.saveToCameraRoll {
                            
                            // Display a message to inform the user of save success
                            let alertController = UIAlertController(title: "", message: "Meme saved to Photos library", preferredStyle: .alert)
                            
                            presentingController.present(alertController, animated: true, completion: nil)
                            
                            // Dissmiss the alert after 2 seconds and dismiss the editor
                            let dismissTime = DispatchTime.now() + 2
                            DispatchQueue.main.asyncAfter(deadline: dismissTime){
                                alertController.dismiss(animated: true, completion: nil)
                                presentingController.presentingViewController?.dismiss(animated: true, completion: nil)
                            }
                            
                        } else {
                            presentingController.presentingViewController?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
        }
        presentingController.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Sound Player
    
    
    /// Plays bullet sound effect with the specified AVAudioPlayer object
    ///
    /// - Parameter player: AVAudioPlayer (use of inout to modify the argument object)
    static func playSoundWith( player: inout AVAudioPlayer){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.explosionAnimatedFinished {
            return
        } else {
            let path = Bundle.main.path(forResource: "Gun", ofType:"mp3")!
            let url = URL(fileURLWithPath: path)
            
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                player = sound
                sound.enableRate = true
                sound.rate = 2.0
                sound.numberOfLoops = 0
                sound.prepareToPlay()
                sound.play()
            } catch {
                debugPrint("Unable to load audio file")
            }

        }
        
    }
    
    
    /// Manage presentation of Meme Editor from Sent Memes screen with bullet sound effect and animation
    ///
    /// - Parameters:
    ///   - emptyView: EmptyDataSetView
    ///   - player: AVAudioPlayer
    ///   - storyboard: Storyboard
    ///   - presentor: UITabBarController
    static func handleOpenMemeEditorAnimationWith(emptyView: EmptyDataSetView, player: inout AVAudioPlayer, storyboard: UIStoryboard, presentor: UITabBarController) {
        
        // If emptyView is visible, show bullet effect and play sound
        if !emptyView.isHidden {
            emptyView.toggleBulletImageViewVisibility(show: true)
            self.playSoundWith(player: &player)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500) , execute: {
            ControllerUtils.presentMemeEditorViewController(fromStoryboard: storyboard, presentor: presentor, withMeme: nil)
        })
        
    }
    
}
