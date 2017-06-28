//
//  Extensions.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 25/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit


extension UIColor {
    
    /// Returns a UIColor object that contrasts the receiver and can be used for foreground text. Credit: Rio Bautista's answer at https://stackoverflow.com/a/39422758
    func maxBright() -> UIColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            let d:CGFloat = 1.0 - max(r,g,b)
            return UIColor(red: r + d, green: g + d , blue: b + d, alpha: 1.0)
            
        }
        return self
    }
    
    var inverted: UIColor {
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        UIColor.red.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: (1 - r), green: (1 - g), blue: (1 - b), alpha: a) // Assuming you want the same alpha value.
    }
}
