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
    private weak var placesListController : PlacesListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.layer.cornerRadius = 60.0 / 2.0
        self.addButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.addButton.layer.borderWidth = 2.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            forBarMetrics: UIBarMetrics.Default)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "places-list-embed-segue" {
            self.placesListController = segue.destinationViewController as! PlacesListViewController
        }
    }
    
    @IBAction func done(segue:UIStoryboardSegue){
        
    }
}