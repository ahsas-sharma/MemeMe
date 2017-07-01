//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 21/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    //TODO: - Add a "swipe to delete” function to your table view to allow users to delete a meme.

    var memes = [Meme]()
    var emptyView: EmptyDataSetView = EmptyDataSetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Get the sent memes from AppDelegate and assign to memes property
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        tableView.reloadData()
        
        if memes.count == 0 {
            print("Should show emptyView")
            self.showEmptyView()
        } else {
            self.hideEmptyView()
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell", for: indexPath) as! SentMemesTableViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.meme = meme
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    
    @IBAction func openMemeEditor(_ sender: UIButton) {
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorNavigationController") 
        
        // Use tabBarController to present the editor otherwise tab and navigation bars appear on top. Since the back button is not required and instead cancel button is used to dismiss the editor, the MemeEditorViewController is presented modally.
        self.tabBarController?.present(memeEditorVC, animated: true, completion: nil)
    }
    
    // MARK: - Empty Data Set View

    func showEmptyView() {
        self.navigationController?.view.addSubview(emptyView)
        emptyView.isHidden = false
        self.navigationController?.view.bringSubview(toFront: emptyView)
    }
    
    func hideEmptyView() {
        emptyView.isHidden = true
        self.navigationController?.view.sendSubview(toBack: emptyView)
    }

    
    
}
