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
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {}
    
    override func setSelected(selected: Bool, animated: Bool) {}
}