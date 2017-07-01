//
//  SelectFontAndColorTableViewCells.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 28/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class SelectFontTableViewCell: UITableViewCell {
    var fontName: String!
    
}

class SelectColorTableViewCell: UITableViewCell {
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    var color: UIColor!

}
