//
//  AddPlaceViewController.swift
//  Places
//
//  Created by William Izzo on 27/10/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import AVFoundation

class AddPlaceViewController: UIViewController {
    @IBOutlet var titleTextField : UITextField!
    private var cameraCapture : CameraCapture!
    
    override func viewDidLoad() {
        CameraCaptureBuilder.build { (session) -> Void in
            self.cameraCapture = session
            self.cameraCapture.beginSession(CameraCapture.CameraCaptureSessionType.BackCamera, didBegin:{ (frontSession) -> Void in
                
                if let sessionPreview = frontSession?.previewLayer() {
                    
                    let bounds = self.view.layer.bounds;
                    sessionPreview.videoGravity = AVLayerVideoGravityResizeAspectFill;
                    sessionPreview.bounds=bounds;

                    
                    sessionPreview.position = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
                    
                    self.view.layer.insertSublayer(sessionPreview, atIndex: 0)

                }
            })
            
            
        }
        
        self.titleTextField.becomeFirstResponder()
    }
    
    @IBAction func didEndEditing(textField:UITextField) {
        textField.resignFirstResponder()
    }
    
    
    @IBAction func addAction(sender:UIButton){
        let place = Place()
        var canAdd = false;
        if let title = self.titleTextField.text {
            place.title = title
            canAdd = true;
        }
        
        guard canAdd == true else {
            // TODO : show alert
            print("Cannot add item with no title")
            return
        }
        
        
        let realm = try! Realm()
        try! realm.write({ () -> Void in
            realm.add(place)
            self.performSegueWithIdentifier("unwind-add-place", sender: self)
        })
    }
}