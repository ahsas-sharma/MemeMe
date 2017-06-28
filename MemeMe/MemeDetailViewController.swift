//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 21/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    var isFullScreen: Bool = false
    
    var originalImageFrame: CGRect!
    var navBarFrame: CGRect!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(openMemeInEditor))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memeImage
    }
    
    // TODO:- When an edited image is being saved, remove the previous copy by holding reference to the index of element in [Meme]
    func openMemeInEditor() {
        let memeEditorNavigationController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorNavigationController") as! UINavigationController
        let memeEditorVC = memeEditorNavigationController.viewControllers.first as! MemeEditorViewController
        memeEditorVC.memeToEdit = meme
        self.tabBarController?.present(memeEditorNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        originalImageFrame = imageView.frame
        
        // If image is not on full screen, do so now
        if !isFullScreen {

            UIView.animate(withDuration: 0.6, animations: {
                UIApplication.shared.isStatusBarHidden = true
                 self.navigationController?.setNavigationBarHidden(self.navigationController?.isNavigationBarHidden == false, animated: true)
                self.hideTabBar()
                imageView.frame = UIScreen.main.bounds
                imageView.backgroundColor = .black
            }, completion: { finished in
                self.isFullScreen = true
            })
            
        } else {
            // If Image is displayed on full screen, return to its original state
            
            UIView.animate(withDuration: 0.5, animations: {
                self.showTabBar()
                self.navigationController?.setNavigationBarHidden(self.navigationController?.isNavigationBarHidden == false, animated: true)
                UIApplication.shared.isStatusBarHidden = false
                sender.view?.frame = self.originalImageFrame
            }, completion: { finished in
                self.isFullScreen = false
            })
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    func hideTabBar() {
        var frame = self.tabBarController?.tabBar.frame
        frame?.origin.y = self.view.frame.size.height + (frame?.size.height)!
        self.tabBarController?.tabBar.frame = frame!
        self.tabBarController?.tabBar.isHidden = true

    }
    
    func showTabBar() {
        var frame = self.tabBarController?.tabBar.frame
        frame?.origin.y = self.view.frame.size.height - (frame?.size.height)!
        self.tabBarController?.tabBar.frame = frame!
        self.tabBarController?.tabBar.isHidden = false

    }
}

