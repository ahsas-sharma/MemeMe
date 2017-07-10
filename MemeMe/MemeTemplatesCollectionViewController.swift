//
//  MemeTemplatesCollectionViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 22/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class MemeTemplatesCollectionViewController: UICollectionViewController {
    
    // MARK: - Outlet and Properties
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var imageFilePaths: [String]!
    var memeEditorVC: MemeEditorViewController!
    
    // MARK: - View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load file paths for all images
        imageFilePaths =  Bundle.main.paths(forResourcesOfType: ".jpg", inDirectory: "/ImgFlip")
        
        // Setup item size and spacing using collection view flow layout
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    // MARK: - Collection View -
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageFilePaths.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeTemplatesCollectionViewCell", for: indexPath) as! MemeTemplatesCollectionViewCell
        cell.imageView.image = UIImage(contentsOfFile: self.imageFilePaths[(indexPath as NSIndexPath).row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        memeEditorVC.imageView.image = UIImage(contentsOfFile: self.imageFilePaths[(indexPath as NSIndexPath).row])
        memeEditorVC.didSelectImage = true
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions -
    
    @IBAction func showCredit(_ sender: Any) {
        let alertController = UIAlertController(title: "Thanks to ImgFlip", message: "All the meme template images were downloaded from ImgFlip. They also have an awesome meme generating community. Check it out at https://imgflip.com/", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
