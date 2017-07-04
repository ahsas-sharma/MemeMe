//
//  ControllerUtils.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 01/07/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit


class ControllerUtils {

    static func toggleEmptyDataSetView(_ view: EmptyDataSetView, superview: UIView, memeCount: Int) {
        if memeCount > 0 {
            view.isHidden = true
            superview.sendSubview(toBack: view)
        } else {
            view.isHidden = false
            superview.bringSubview(toFront: view)
        }
    }
    
    static func presentMemeEditorViewController(fromStoryboard: UIStoryboard, presentor: UITabBarController, withMeme: Meme?) {
        let memeEditorNavigationController = fromStoryboard.instantiateViewController(withIdentifier: "MemeEditorNavigationController") as! UINavigationController
        if withMeme != nil {
            let memeEditorVC = memeEditorNavigationController.viewControllers.first as! MemeEditorViewController
            memeEditorVC.memeToEdit = withMeme
        }
        presentor.present(memeEditorNavigationController, animated: true, completion: nil)

    }
    
    static func pushMemeDetailViewController(fromStoryboard: UIStoryboard, presentor: UINavigationController, withMeme: Meme) {
        let memeDetailVC = fromStoryboard.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = withMeme
        presentor.pushViewController(memeDetailVC, animated: true)
    }
    
    typealias saveHandler = ()  -> Void
    
    static func presentShareActivityControllerWithOptions(memeImage: UIImage, presentor: Any, sourceView: UIView, createNew: Bool, saveHandler: saveHandler?) {
   
        var presentingController = presentor as! UIViewController
        
        // Setup the activity view controller
        let imageToShare = [memeImage]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
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
                    
                    if createNew {
                       saveHandler!()
                    }
                    
                    // If user selects 'Save Image' and the task completes, display a success message
                    if activityType == UIActivityType.saveToCameraRoll && completed {
                        
                        // Display a message to inform the user of save success
                        let alertController = UIAlertController(title: "", message: "Meme saved to Photos library!", preferredStyle: .alert)
                        presentingController.present(alertController, animated: true, completion: nil)
                        
                        // Dissmiss the alert after 2 seconds
                        let dismissTime = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: dismissTime){
                            alertController.dismiss(animated: true, completion: nil)
                            presentingController.presentingViewController?.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                    
                }
        }
      
        presentingController.present(activityViewController, animated: true, completion: nil)

    }
    
//    func openMemeEditor(from controller: Any, withMeme: Meme?) {
//        let memeEditorNavigationController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorNavigationController") as! UINavigationController
//        let memeEditorVC = memeEditorNavigationController.viewControllers.first as! MemeEditorViewController
//        memeEditorVC.memeToEdit = meme
//        self.tabBarController?.present(memeEditorNavigationController, animated: true, completion: nil)
//    }
}
