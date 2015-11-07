//
//  MainViewController.swift
//  Places
//
//  Created by William Izzo on 27/10/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
class MainViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    private var gpsSession : GpsSingleLocationSession?
    override func viewDidLoad() {        
        self.addButton.layer.cornerRadius = 60.0 / 2.0
        self.addButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.addButton.layer.borderWidth = 2.0
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    @IBAction func done(segue:UIStoryboardSegue){

    }
}