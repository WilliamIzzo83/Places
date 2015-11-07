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
import CoreLocation
class AddPlaceViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var titleTextField : UITextField!
    @IBOutlet var placeTitleOverlay : UIView!
    @IBOutlet weak var addButtonBkg: UIView!
    @IBOutlet weak var addButtonInnerView: UIView!
    private var forceResignResponder = false
    private var cameraCapture : CameraCapture!
    private var gpsSession : GpsSingleLocationSession?
    
    @IBOutlet weak var addressTextField: UITextField!
    override func viewDidLoad() {
        self.forceResignResponder = false
        self.titleTextField.becomeFirstResponder()
        self.addButtonBkg.layer.cornerRadius = 40.0
        self.addButtonInnerView.layer.cornerRadius = 35
        
        self.addButtonInnerView.layer.borderWidth = 3
        self.addButtonInnerView.layer.borderColor = UIColor.blackColor().CGColor
        
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
        
        Gps.singleLocationSession(.WhenInUse) { (session) -> Void in
            self.gpsSession = session
            self.gpsSession?.getLocation({ (sender, location) -> Void in
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) -> Void in
                    if let placemark = placeMarks?.first {
                        self.addressTextField.text = placemark.thoroughfare
                    }
                })
            })
        }
    }
    
    @IBAction func porcodio(textfield:UITextField) {
        if let text = textfield.text {
            guard text.characters.count > 0 else {
                return
            }
            textfield.resignFirstResponder()
            UIView.animateWithDuration(
                0.4,
                delay: 0.3,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: { () -> Void in
                    self.placeTitleOverlay.alpha = 0.0
                },
                completion: nil)
        }
    }
   
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        guard self.forceResignResponder == false else {
            return true
        }
        
        if let text = textField.text {
            guard text.characters.count > 0 else {
                return false
            }
            return true
        }
        return false
    }
    override func viewWillDisappear(animated: Bool) {
        self.forceResignResponder = true
        self.titleTextField.resignFirstResponder()
    }
    @IBAction func addTouchDown(sender: AnyObject) {
        self.addButtonInnerView.backgroundColor = UIColor.grayColor()
    }
    @IBAction func addTouchExit(sender: AnyObject) {
        self.addButtonInnerView.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func reinputTitle(sender: AnyObject) {
        UIView.animateWithDuration(
            0.4,
            delay: 0.2,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () -> Void in
                self.placeTitleOverlay.alpha = 1.0
            },
            completion: { (completed)->Void in
                self.titleTextField.becomeFirstResponder()
        })
    }
    
    @IBAction func addAction(sender:UIButton){
        self.addButtonInnerView.backgroundColor = UIColor.whiteColor()
        
        let place = Place()
        
        if let title = self.titleTextField.text {
            place.title = title
        }
        
        self.gpsSession?.getLocation({ (sender, location) -> Void in
            place.latitude = location.coordinate.latitude
            place.longitude = location.coordinate.longitude
            
            self.tryWritePlace(place)
        })
        
        self.cameraCapture.currentSession?.captureFrame({ (imageData, error) -> Void in
            if imageData != nil {
                let imageUID = NSUUID().UUIDString
                writeDataInLibraryPath(imageData!, filename: imageUID)
                
                place.imageUID = imageUID
                
                self.tryWritePlace(place)
            }
            
        })
    }
    
    private func tryWritePlace(place:Place) {
        var canAdd = true
        
        if place.title == "" {
            canAdd = false
        }
        
        if place.longitude == 0 || place.latitude == 0 {
            canAdd = false
        }
        
        if place.imageUID == "" {
            canAdd = false
        }
        
        if let address = self.addressTextField.text {
            place.address = address
        } else {
            canAdd = false
        }
        
        if canAdd {
            let realm = try! Realm()
            try! realm.write({ () -> Void in
                realm.add(place)
                self.performSegueWithIdentifier("unwind-add-place", sender: self)
            })
        }
    }
}