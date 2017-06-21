//
//  Meme.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 14/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

struct Meme {
    
    // MARK:- Properties -
    
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memeImage: UIImage
    
    // MARK:- Initializer -
    
    init(topText: String, bottomText: String, originalImage: UIImage, memeImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memeImage = memeImage
    }
}
