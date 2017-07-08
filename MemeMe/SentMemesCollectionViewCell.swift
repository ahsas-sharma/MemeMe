//
//  SentMemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 21/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SentMemesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme! {
        didSet {
            self.imageView.image = meme.memeImage
        }
    }
}
