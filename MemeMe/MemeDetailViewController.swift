//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 21/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: - Outlets and Properties -
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    var isFullScreen: Bool = false
    
    var originalImageFrame: CGRect!
    var navBarFrame: CGRect!
    
 
    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(openMemeInEditor))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memeImage
    }
    
   
    // MARK: - Actions -
    
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
    
    func openMemeInEditor() {
        ControllerUtils.presentMemeEditorViewController(fromStoryboard: self.storyboard!, presentor: self.tabBarController!, withMeme: meme)
    }
    
    
    // MARK: - Helper -
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    func hideTabBar() {
        print("Hiding Tab Bar")
        var frame = self.tabBarController?.tabBar.frame
        print("tabBar.frame :\(String(describing: frame))")
        frame?.origin.y = self.view.frame.size.height + (frame?.size.height)!
        print("frame.origin.y : \(String(describing: frame?.origin.y))")
        self.tabBarController?.tabBar.frame = frame!
        self.tabBarController?.tabBar.isHidden = true

    }
    
    func showTabBar() {
        print("Showing tab bar")
        var frame = self.tabBarController?.tabBar.frame
        print("tabBar.frame :\(String(describing: frame))")
        frame?.origin.y = self.view.frame.size.height - (frame?.size.height)!
        print("frame.origin.y : \(String(describing: frame?.origin.y))")
        self.tabBarController?.tabBar.frame = frame!
        self.tabBarController?.tabBar.isHidden = false

    }
}

