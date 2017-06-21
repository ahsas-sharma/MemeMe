//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 21/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var meme: Meme! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        self.memeImageView.image = meme.memeImage
        self.topLabel.text = meme.topText
        self.bottomLabel.text = meme.bottomText
    }
}


