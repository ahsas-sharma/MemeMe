//
//  EmptyDataSetView.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 01/07/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class EmptyDataSetView : UIView {
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var tapAboveLabel: UILabel!
    @IBOutlet weak var doubleMemeLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    private func setupView() {
        
        Bundle.main.loadNibNamed("EmptyDataSetView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    }

  
}
