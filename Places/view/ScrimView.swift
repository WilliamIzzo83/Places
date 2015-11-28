//
//  ScrimView.swift
//  Places
//
//  Created by William Izzo on 28/11/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import UIKit

class ScrimView: UIView {

    private weak var scrimLayer : CAGradientLayer?

    var gradientColors : [UIColor]? {
        set(value) {
            if scrimLayer == nil {
                let scrim = CAGradientLayer()
                self.layer.insertSublayer(scrim, atIndex: 0)
                
                self.scrimLayer = scrim
            }
            
            var cgColors = [CGColor]()            
            for color in value! {
                cgColors.append(color.CGColor)
            }
            
            self.scrimLayer?.colors = cgColors
        }

        get {
            return nil
        }
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        self.scrimLayer?.frame = self.bounds
    }

}
