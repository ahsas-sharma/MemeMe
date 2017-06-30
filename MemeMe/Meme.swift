//
//  Meme.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 14/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

// MARK:- Meme -

struct Meme {

    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memeImage: UIImage
    
    // Used to store any custom text attributes set by the user
    var textAttributes: TextAttributes
}

// MARK:- TextAttributes -

struct TextAttributes {
    
    var fontName: String
    var fontSize: CGFloat
    var fontColor: UIColor
    var borderWidth: Int
    var borderColor: UIColor
    
    var topTextFieldCenter: CGPoint?
    var bottomTextFieldCenter: CGPoint?
    
    // Returns a dictionary for creating an NSAttributedString or setting defaultTextAttributes of UITextField
    func dictionary() -> [String: Any] {
        let attributesDict:[String:Any] = [
        NSStrokeColorAttributeName : self.borderColor,
        NSForegroundColorAttributeName: self.fontColor,
        NSStrokeWidthAttributeName: self.borderWidth,
        NSFontAttributeName: UIFont(name: self.fontName, size: self.fontSize)!]
    
        return attributesDict
    }
    
}

