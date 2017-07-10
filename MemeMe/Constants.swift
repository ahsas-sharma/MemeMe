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
        
        // Populate fonts array while making sure Impact is the first font
        var fontsArray = [String]()
        for family in UIFont.familyNames {
            for font in UIFont.fontNames(forFamilyName: family) {
                font != "Impact" ? fontsArray.append(font) : ()
            }
        }
        fontsArray.sort()
        fontsArray.insert("Impact", at: 0)
        return fontsArray
    }
    
    // Store default center CGPoint values for both textfields when meme editor loads
    static var defaultTopTextFieldCenter: CGPoint!
    static var defaultBottomTextFieldCenter: CGPoint!
    
    // Stores default text attributes for the text fields
    static let defaultTextAttributes = TextAttributes(fontName: "Impact", fontSize: 40, fontColor: UIColor.white, borderWidth: -5, borderColor: UIColor.black, topTextFieldCenter: nil, bottomTextFieldCenter: nil)
    
    // Default preview text
    static let previewText = "THIS IS MEME ME!"
    
    // MARK: - Colors -
    
    struct Colors {
        
        static let blackDark = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1.0)
        static let blackLight = UIColor.init(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0)
        static let white = UIColor.white
        
        // Flat UI colors (rgba values taken from https://www.materialui.co/flatuicolors)
        static let turquoise = UIColor.init(red: 26/255, green: 188/255, blue: 156/255, alpha: 1.0)
        static let greensea = UIColor.init(red: 22/255, green: 160/255, blue: 133/255, alpha: 1.0)
        static let emerald = UIColor.init(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
        static let nephritis = UIColor.init(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0)
        static let peterriver = UIColor.init(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        static let belizehole = UIColor.init(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
        static let sunflower = UIColor.init(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0)
        static let orange = UIColor.init(red: 243/255, green: 156/255, blue: 18/255, alpha: 1.0)
        static let carrot = UIColor.init(red: 230/255, green: 126/255, blue: 34/255, alpha: 1.0)
        static let pumpkin = UIColor.init(red: 211/255, green: 84/255, blue: 0/255, alpha: 1.0)
        static let alizarin = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        static let pomegranate = UIColor.init(red: 192/255, green: 57/255, blue: 43/255, alpha: 1.0)
        static let clouds = UIColor.init(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
        static let silver = UIColor.init(red: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)
        static let concrete = UIColor.init(red: 149/255, green: 165/255, blue: 166/255, alpha: 1.0)
        static let asbestos = UIColor.init(red: 127/255, green: 140/255, blue: 141/255, alpha: 1.0)
        static let amethyst = UIColor.init(red: 155/255, green: 89/255, blue: 182/255, alpha: 1.0)
        static let wisteria = UIColor.init(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        static let wetasphalt = UIColor.init(red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0)
        static let midnightblue = UIColor.init(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        static func array() -> [UIColor] {
            return [blackDark, blackLight, white, turquoise, greensea, emerald, nephritis, peterriver, belizehole, sunflower, orange, carrot, pumpkin, alizarin, pomegranate, clouds, silver, concrete, asbestos, amethyst, wisteria, wetasphalt, midnightblue]
        }
    }
    
}
