//
//  MainViewController.swift
//  Places
//
//  Created by William Izzo on 27/10/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        self.addButton.layer.cornerRadius = 60.0 / 2.0
        self.addButton.layer.borderColor = UIColor.blackColor().CGColor
        self.addButton.layer.borderWidth = 1.0
    }
    
    @IBAction func done(segue:UIStoryboardSegue){
        
    }
}