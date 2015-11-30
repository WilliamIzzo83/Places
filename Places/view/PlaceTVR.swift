//
//  PlaceTVR.swift
//  Places
//
//  Created by William Izzo on 27/10/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import Foundation
import UIKit

class PlaceTVR : UITableViewCell {
    @IBOutlet var placeImage : UIImageView!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var addressLabel : UILabel!
    @IBOutlet var shadowView : UIView!
    @IBOutlet weak var scrimView: ScrimView!
    
    weak var scrimLayer : CAGradientLayer?
    static let shadowRadius = CGFloat(1.2)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        self.shadowView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
//        self.shadowView.layer.shadowRadius = PlaceTVR.shadowRadius
//        self.shadowView.layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).CGColor
//        self.shadowView.layer.shadowOpacity = 0.6
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
//        let shadowAnim = CABasicAnimation(keyPath: "shadowRadius")
//        shadowAnim.fromValue = CGFloat(highlighted) * PlaceTVR.shadowRadius
//        shadowAnim.toValue = CGFloat(!highlighted) * PlaceTVR.shadowRadius
//        shadowAnim.duration = 0.12
//        
//        self.shadowView.layer.shadowRadius = CGFloat(!highlighted) * PlaceTVR.shadowRadius
//        self.shadowView.layer.addAnimation(shadowAnim, forKey: "shadowAnimations")
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {}
}