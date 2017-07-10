//
//  SettingsColorSelectionTableViewCell.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 30/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SettingsFontColorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorView: UIView!
    var selectedColor: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let selectedColor = selectedColor {
            self.colorView.backgroundColor = selectedColor
        }
    }
    
    // Empty implementation to fix a bug that causes cell's subviews backgroundColor property to become transparent
    override func setSelected(_ selected: Bool, animated: Bool) {
        // Please do nothing. Thank you!
    }
    
}

class SettingsBorderColorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorView: UIView!
    var selectedColor: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let selectedColor = selectedColor {
            self.colorView.backgroundColor = selectedColor
        }
    }
    
    // Empty implementation to fix a bug that causes cell's subviews backgroundColor property to become transparent
    override func setSelected(_ selected: Bool, animated: Bool) {
        // Please do nothing. Thank you!
    }
    
}
