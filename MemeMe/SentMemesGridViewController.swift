//
//  SentMemesGridViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 21/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit
import AVFoundation

class SentMemesGridViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var emptyView: EmptyDataSetView!
    
    var player: AVAudioPlayer = AVAudioPlayer()
    let minimumPressDuration = 0.5
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes = [Meme]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup item size and spacing using collection view flow layout
        let space:CGFloat = 0.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        // Setup long press gesture recognizer for UICollectionViewCell action sheet
        let longPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.collectionView.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the sent memes from AppDelegate and reload collectionView
        memes = appDelegate.memes
        collectionView?.reloadData()
        
        // Toggle empty data set view based on meme count
        ControllerUtils.toggleEmptyDataSetView(emptyView, superview: self.view, memeCount: memes.count)
        
    }
    
    // MARK: - Actions
    
    @IBAction func openMemeEditor(_ sender: UIButton) {
        ControllerUtils.handleOpenMemeEditorAnimationWith(emptyView: self.emptyView, player: &self.player, storyboard: self.storyboard!, presentor: self.tabBarController!)
    }
    
    // MARK: - Helper
    
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .ended {
            return
        }
        
        let point = gestureRecognizer.location(in: self.collectionView)
        
        if let indexPath: IndexPath = (self.collectionView.indexPathForItem(at: point)) {
            let selectedMeme = self.memes[indexPath.row]
            self.presentActionSheetFor(meme: selectedMeme, atIndexPath: indexPath)
        }
    }
    
    
    /// Presents action sheet for the selected Meme with Delete, Share and Edit actions
    ///
    /// - Parameters:
    ///   - meme: selected Meme object
    ///   - atIndexPath: indexPath of the selected Meme object
    func presentActionSheetFor(meme: Meme, atIndexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.memes.remove(at: atIndexPath.row)
            self.appDelegate.memes.remove(at: atIndexPath.row)
            self.collectionView.deleteItems(at: [atIndexPath])
            self.collectionView.reloadData()
            ControllerUtils.toggleEmptyDataSetView(self.emptyView, superview: self.view, memeCount: self.memes.count)
        })
        alertController.addAction(deleteAction)
        
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: { _ in
            ControllerUtils.presentShareActivityControllerWithOptions(memeImage: meme.memeImage, presentor: self.tabBarController!, sourceView: self.view, createNew: false, saveHandler: nil)
        })
        alertController.addAction(shareAction)
        
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { _ in
            ControllerUtils.presentMemeEditorViewController(fromStoryboard: self.storyboard!, presentor: self.tabBarController!, withMeme: meme)
            
        })
        alertController.addAction(editAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        
        // Fix crash for iPad and setup the popover
        if UIDevice.current.userInterfaceIdiom == .pad {
            let popover = alertController.popoverPresentationController
            popover?.sourceView = collectionView.cellForItem(at: atIndexPath)
            popover?.sourceRect = (collectionView.cellForItem(at: atIndexPath)?.bounds)!
            popover?.permittedArrowDirections = .any
            popover?.backgroundColor = .black
        }
        
        self.present(alertController, animated: true, completion: nil)
        
        // Restyle the view of alertController
        alertController.view.tintColor = .white
        
        // Search for visualEffectView using the UIView extension and change to dark style
        if let visualEffectView = alertController.view.searchVisualEffectsSubview()
        {
            visualEffectView.effect = UIBlurEffect(style: .dark)
        }
    }
}

// MARK: - Collection View -

extension SentMemesGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        cell.meme = self.memes[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedMeme = memes[(indexPath as NSIndexPath).row]
        ControllerUtils.pushMemeDetailViewController(fromStoryboard: self.storyboard!, presentor: self.navigationController!, withMeme: selectedMeme)
    }
}


