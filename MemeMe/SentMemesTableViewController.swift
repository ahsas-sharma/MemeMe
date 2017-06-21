//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 21/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the sent memes from AppDelegate and assign to memes property
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
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
    
    
}
