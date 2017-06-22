//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 21/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Get the sent memes from AppDelegate and assign to memes property
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        print("SentMemesTableViewController: viewWillAppear: reloadData()")
        tableView.reloadData()
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
        let memeEditorVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
//        memeEditorVC.modalPresentationStyle = .fullScreen
        
        // Use tabBarController to present the editor otherwise tabBar and navigation bar appear on top
        self.tabBarController?.present(memeEditorVC, animated: true, completion: nil)
    }

    
    
}
