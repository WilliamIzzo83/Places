//
//  DetailViewController.swift
//  Places
//
//  Created by William Izzo on 07/11/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController {
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var place : Place!
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let imageUID = self.place.imageUID
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            if let imageData = readDataInLibraryPath(imageUID) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.placeImageView.image = UIImage(data: imageData)
                })
            }
        }
        
        self.titleLabel.text = self.place.title
        self.addressLabel.text = self.place.longAddress
    }
    
    @IBAction func cancelButtonAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}