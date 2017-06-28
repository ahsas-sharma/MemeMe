//
//  Constants.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 25/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

struct Constants {

    // MARK: - Meme Text Settings -
    
    // Stores an array of font names
    static var fonts : [String] {
        
        // Populate fonts array
        var fontsArray = [String]()
        for family in UIFont.familyNames {
            for font in UIFont.fontNames(forFamilyName: family) {
                fontsArray.append(font)
            }
        }
        fontsArray.sort()
        return fontsArray
    }
    
    // Stores default text attributes for the text fields in textAttributes struct
    static let defaultTextAttributes = TextAttributes(fontName: "Impact", fontSize: 30, fontColor: UIColor.white, borderWidth: -5, borderColor: UIColor.black, topTextFieldCenter: nil, bottomTextFieldCenter: nil)

    // Default preview text
    static let previewText = "THIS IS MEME ME!"
    
}
