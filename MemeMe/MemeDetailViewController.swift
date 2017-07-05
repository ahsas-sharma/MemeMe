//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 21/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Outlets and Properties -
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    var isFullScreen: Bool = false
    
    var defaultImageFrame: CGRect!
    var defaultNavBarFrame: CGRect!
    var defaultTabBarFrame: CGRect!
    
    var screenSize: CGRect = UIScreen.main.bounds
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(openMemeInEditor))
        self.navigationItem.rightBarButtonItem = editButton
        updateScreenElementsSizeValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memeImage
    }

    // MARK: - Actions -
    
    /// Handles display of image on full screen. If image is not fullscreen, hide tab, status and navigation bar and make image full screen, else return to its original size and show other elements
    /// - parameter sender: UITapGestureRecognizer
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        self.updateScreenElementsSizeValues()

        if !isFullScreen {
            UIView.animate(withDuration: 0.5, animations: {
                self.hideTabBar()
                UIApplication.shared.isStatusBarHidden = true
                self.navigationController?.setNavigationBarHidden(self.navigationController?.isNavigationBarHidden == false, animated: true)
                self.imageView.frame = self.screenSize
            }, completion: { finished in
                self.isFullScreen = true
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationController?.setNavigationBarHidden(self.navigationController?.isNavigationBarHidden == false, animated: true)
                self.showTabBar()
                UIApplication.shared.isStatusBarHidden = false
                self.imageView.frame = self.defaultImageFrame
                self.imageView.frame.origin.y = 0
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
        var frame =  self.tabBarController?.tabBar.frame
        frame?.origin.y = screenSize.maxY
        self.tabBarController?.tabBar.frame = frame!
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.frame = defaultTabBarFrame
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// Update screen size, navigation bar, tab bar and image frame values based on screen orientation
    func updateScreenElementsSizeValues() {
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        if UIDevice.current.orientation.isLandscape {
            self.defaultNavBarFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
            self.defaultTabBarFrame = CGRect(x: 0, y: (screenHeight - 49), width: screenWidth, height: 49)
            self.defaultImageFrame = CGRect(x:0, y: 0, width: screenWidth, height: (defaultTabBarFrame.origin.y - defaultNavBarFrame.height))
        }
        
        if UIDevice.current.orientation.isPortrait{
            self.defaultNavBarFrame = CGRect(x: 0, y: 0, width: screenWidth, height: 64)
            self.defaultTabBarFrame = CGRect(x: 0, y: (screenHeight - 49), width: screenWidth, height: 49)
            self.defaultImageFrame = CGRect(x:0, y: 0, width: screenWidth, height: (defaultTabBarFrame.origin.y - defaultNavBarFrame.height))

        }
    }
    
}

