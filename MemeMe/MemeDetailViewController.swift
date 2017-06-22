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
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        memeEditorVC.memeToEdit = meme
        self.tabBarController?.present(memeEditorVC, animated: true, completion: nil)
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

//        UIView.animate(withDuration: 0.5, animations: {
//            self.tabBarController?.tabBar.frame = frame!
//        })
    }
    
    func showTabBar() {
        var frame = self.tabBarController?.tabBar.frame
        frame?.origin.y = self.view.frame.size.height - (frame?.size.height)!
        self.tabBarController?.tabBar.frame = frame!
        self.tabBarController?.tabBar.isHidden = false

//        UIView.animate(withDuration: 0.5, animations: {
//            self.tabBarController?.tabBar.frame = frame!
//        })
    }
}








/*
 
 @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
 let imageView = sender.view as! UIImageView
 
 // If image is not on full screen, do so now
 if !isFullScreen {
 
 originalImageFrame = imageView.frame
 navBarFrame = self.navigationController?.navigationBar.frame
 tabBarFrame = self.tabBarController?.tabBar.frame
 
 UIView.animate(withDuration: 0.5, animations: {
 print("UIScreen.main.bounds: \(UIScreen.main.bounds)")
 print("UIScreen.main.bounds.origin: \(UIScreen.main.bounds.origin)")
 print("imageView.bounds: \(imageView.bounds)")
 print("imageView.frame: \(imageView.frame)")
 print("navBarFrame: \(self.navBarFrame)")
 print("tabBarFrame: \(self.tabBarFrame)")
 imageView.bounds = UIScreen.main.bounds
 imageView.frame.origin = CGPoint(x: 0, y: 0)
 imageView.backgroundColor = .black
 //                self.navigationController?.navigationBar.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: 0, height: 0)
 self.tabBarController?.tabBar.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.maxY, width: 0, height: 0)
 })
 
 //            self.navigationController?.isNavigationBarHidden = true
 self.tabBarController?.tabBar.isHidden = true
 isFullScreen = true
 
 print("----------------AFTER ANIMATION ---------------- ")
 print("UIScreen.main.bounds: \(UIScreen.main.bounds)")
 print("UIScreen.main.bounds.origin: \(UIScreen.main.bounds.origin)")
 print("imageView.bounds: \(imageView.bounds)")
 print("imageView.frame: \(imageView.frame)")
 print("navBarFrame: \(self.navBarFrame)")
 print("tabBarFrame: \(self.tabBarFrame)")
 
 } else {
 // If Image is displayed on full screen, return to its original state
 UIView.animate(withDuration: 0.5, animations: {
 sender.view?.frame = self.originalImageFrame
 self.navigationController?.navigationBar.frame = self.navBarFrame
 self.tabBarController?.tabBar.frame = self.tabBarFrame
 })
 self.navigationController?.isNavigationBarHidden = false
 self.tabBarController?.tabBar.isHidden = false
 isFullScreen = false
 }
 }
 
 */
