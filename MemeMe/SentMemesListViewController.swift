//
//  SentMemesListViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 21/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SentMemesListViewController: UIViewController {
    
    //TODO: - Add a "swipe to delete” function to your table view to allow users to delete a meme.

    var memes = [Meme]()
    var animatedImage: UIImage!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBOutlet weak var emptyView: EmptyDataSetView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let animatedImage = createExplosionAnimationImage()
//        emptyView.explosionImageView.image = animatedImage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Get the sent memes from AppDelegate and reload tableView
        memes = appDelegate.memes
        tableView.reloadData()
        
        // Toggle empty data set view based on meme count
        ControllerUtils.toggleEmptyDataSetView(emptyView, superview: self.view, memeCount: memes.count)
        
    }
    
    @IBAction func openMemeEditor(_ sender: UIButton) {
        ControllerUtils.presentMemeEditorViewController(fromStoryboard: self.storyboard!, presentor: self.tabBarController!, withMeme: nil)
    }
    
    // MARK: - Explosion Animation -
    
    func createExplosionAnimationImage() -> UIImage? {
        var explosionFrames = [UIImage]()
        
        for i in 1...48 {
            let imageNumber = String(format: "%02d", i)
            let image = UIImage(named: "explosion_\(imageNumber)")!
            explosionFrames.append(image)
        }
        
        let animatedImage = UIImage.animatedImage(with: explosionFrames, duration: 1.0)
        return animatedImage
    }
    
    // MARK: - Edit / Share -
//
//    @IBAction func editButtonPressed(){
//        tableView.setEditing(!tableView.isEditing, animated: true)
//        if tableView.isEditing == true{
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(editButtonPressed))
//        } else{
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editButtonPressed))
//        }
//    }
    
    
}

// MARK: - Table View Delegate-

extension SentMemesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell", for: indexPath) as! SentMemesTableViewCell
        
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.meme = meme
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let selectedMeme = memes[(indexPath as NSIndexPath).row]
        ControllerUtils.pushMemeDetailViewController(fromStoryboard: self.storyboard!, presentor: self.navigationController!, withMeme: selectedMeme)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: {action, index in
            print("Edited a meme")
        })
        edit.backgroundColor = Constants.Colors.peterriver
        let share = UITableViewRowAction(style: .normal, title: "Share", handler: {action, index in
            
            let memeImage = (self.memes[indexPath.row]).memeImage
            ControllerUtils.presentShareActivityControllerWithOptions(memeImage: memeImage, presentor: self, sourceView: self.view, createNew: false, saveHandler: nil)
            print("Open share meme activity controller")
            
        })
        share.backgroundColor = Constants.Colors.carrot
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {action, index in
            tableView.beginUpdates()
            self.appDelegate.memes.remove(at: indexPath.row)
            self.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            print("Deleted a Meme")
        })
        
        return [delete, edit, share]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Empty implementation to enable swipe actions as defined in the function above.
    }
 
}


