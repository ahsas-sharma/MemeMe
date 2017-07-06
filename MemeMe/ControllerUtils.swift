//
//  ControllerUtils.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 01/07/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit


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
            view.isHidden = false
            view.tapAboveLabel.isHidden = false
            superview.bringSubview(toFront: view)
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
    ///   - memeImage: Meme to share
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
                        createNew ? saveHandler!() : ()
                        
                        // If user selects 'Save Image', display a success message
                        if activityType == UIActivityType.saveToCameraRoll {
                            
                            // Display a message to inform the user of save success
                            let alertController = UIAlertController(title: "", message: "Meme saved to Photos library", preferredStyle: .alert)
                            // Customize the color
                            
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
    
    // MARK: - Explosion Animation
    
    
    /// Handles the display of explosion animation and altering visibility of related UI elements based on the memes array in AppDelegate
    ///
    /// - Parameter emptyView: EmptyDataSetView that is the superview for the explosionImageView and related UI elements.
    static func handleExplosionAnimationStateFor(emptyView:EmptyDataSetView) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.memes.count > 0 {
            emptyView.explosionImageView.isHidden = true
            emptyView.tapAboveLabel.isHidden = true
            emptyView.explosionImageView.stopAnimating()
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                emptyView.tapAboveLabel.isHidden = true
                emptyView.explosionImageView.isHidden = false
                emptyView.explosionImageView.startAnimating()
            })
        }
    }
}
