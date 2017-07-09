//
//  EmptyDataSetView.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 01/07/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit
import AVFoundation

class EmptyDataSetView : UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var tapAboveLabel: UILabel!
    @IBOutlet weak var doubleMemeLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bulletImageView: UIImageView!
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    // MARK: - Helper
    
    private func setupView() {
        Bundle.main.loadNibNamed("EmptyDataSetView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        doubleMemeLabel.attributedText = NSAttributedString(string: "I DOUBLE MEME YOU!", attributes: Constants.defaultTextAttributes.dictionary())
        tapAboveLabel.attributedText = NSAttributedString(string: "TAP ADD TO BEGIN", attributes: Constants.defaultTextAttributes.dictionary())
        bulletImageView.isHidden = true
    }
    
 
    func toggleBulletImageViewVisibility(show: Bool) {
        self.bulletImageView.isHidden = !show
    }

   
}
