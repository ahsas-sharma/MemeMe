//
//  EmptyDataSetView.swift
//  MemeMe
//
//  Created by Ahsas Sharma on 01/07/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit

class EmptyDataSetView : UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var tapAboveLabel: UILabel!
    @IBOutlet weak var doubleMemeLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var explosionImageView: UIImageView!
    
    
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
        explosionImageView.isHidden = true
        prepareExplosionAnimation()

    }
    
    
    /// Create an array of explosion images and prepare explosionImageView with the animation images and options
    private func prepareExplosionAnimation() {
        var explosionFrames = [UIImage]()
        
        for i in 1...48 {
            let imageNumber = String(format: "%02d", i)
            let image = UIImage(named: "explosion_\(imageNumber)")!
            explosionFrames.append(image)
        }
        
        explosionImageView.animationImages = explosionFrames
        explosionImageView.animationDuration = 0.5
        explosionImageView.animationRepeatCount = 1
    }
    
    func handleExplosionAnimationState() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.memes.count > 0 {
            explosionImageView.isHidden = true
            tapAboveLabel.isHidden = true
            self.explosionImageView.stopAnimating()
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.tapAboveLabel.isHidden = true
                self.explosionImageView.isHidden = false
                self.explosionImageView.startAnimating()
            })
        }

    }


  
}
