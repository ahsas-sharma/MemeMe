//
//  UIViewExtensions.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 08/07/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit


extension UIView
{

    /// Searches visualEffectView subviews to be used for applying dark blur effect
    ///
    /// - Returns: UIVisualEffectView?
    func searchVisualEffectsSubview() -> UIVisualEffectView?
    {
        if let visualEffectView = self as? UIVisualEffectView
        {
            return visualEffectView
        }
        else
        {
            for subview in subviews
            {
                if let found = subview.searchVisualEffectsSubview()
                {
                    return found
                }
            }
        }
        
        return nil
    }
}

