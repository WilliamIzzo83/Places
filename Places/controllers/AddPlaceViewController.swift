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
import AddressBookUI
import Contacts

private class PlaceBuilder {
    typealias didBuildPlaceListener = (place:Place) -> Void
    private var didBuildPlace : didBuildPlaceListener!
    private var place = Place()
    
    init (didBuildPlace:didBuildPlaceListener) {
        self.didBuildPlace = didBuildPlace
    }
    
    var title : String {
        get {
            return place.title
        }
        set(value) {
            place.title = value
            self.tryNotifyPlaceIsBuilt()
        }
    }
    
    var location : CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        }
        
        set(value) {
            place.latitude = value.latitude
            place.longitude = value.longitude
            self.tryNotifyPlaceIsBuilt()
        }
    }
    
    var address : NSDictionary? {
        get {
            guard place.addressData != nil else {
                return nil
            }
            
            let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(place.addressData!) as! NSDictionary
            return dictionary
        }
        
        set(value) {
            if let dictionary = value {
                place.addressData = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
                
                
                // Thoroughfare, ZIP City, SubAdministrativeArea, Country
                var fullAddress = String()
                if let thoroughfare  = dictionary["Street"] as? String {
                    fullAddress += thoroughfare
                }
                
                if let zip  = dictionary["ZIP"] as? String {
                    fullAddress += ", " + zip
                }
                
                if let subAdArea = dictionary["SubAdministrativeArea"] as? String {
                    fullAddress += " " + subAdArea
                }
                
                if let country = dictionary["Country"] as? String {
                    fullAddress += ", " + country
                }
                
                place.longAddress = fullAddress
                place.shortAddress = dictionary["Street"] as? String
                
                self.tryNotifyPlaceIsBuilt()
            }
        }
    }
    
    var imageUID : String {
        get {
            return self.place.imageUID
        }
        
        set(value) {
            self.place.imageUID = value
            self.tryNotifyPlaceIsBuilt()
            
        }
    }
    
    private func tryNotifyPlaceIsBuilt() {
        guard place.title != "" else {
            return
        }
        
        guard place.addressData != nil else {
            return
        }
        
        guard place.latitude != 0.0 && place.longitude != 0.0 else {
            return
        }
        
        guard place.imageUID != "" else {
            return
        }
        
        place.timestamp = NSDate().timeIntervalSince1970
        
        self.didBuildPlace(place:self.place)
    }
    
}

class AddPlaceViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var titleTextField : UITextField!
    @IBOutlet var placeTitleOverlay : UIView!
    @IBOutlet weak var addButtonBkg: UIView!
    @IBOutlet weak var addButtonInnerView: UIView!
    
    private var forceResignResponder = false
    private var cameraCapture : CameraCapture!
    private var gpsSession : GpsSingleLocationSession?
    private var placeBuilder  : PlaceBuilder!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    private var overlayPlaceDataViewHidden : Bool {
        get {
            return self.placeTitleOverlay.hidden
        }
        
        set(value) {
            if value == false {
                self.placeTitleOverlay.hidden = false
                self.placeTitleOverlay.alpha = 0.0
                UIView.animateWithDuration(
                    0.25,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseIn,
                    animations: { () -> Void in
                        self.placeTitleOverlay.alpha = 1.0
                    },
                    completion: nil)
            } else {
                self.placeTitleOverlay.alpha = 1.0
                UIView.animateWithDuration(
                    0.25,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseIn,
                    animations: { () -> Void in
                        self.placeTitleOverlay.alpha = 0.0
                    },
                    completion: { (completed:Bool) -> Void in
                        self.placeTitleOverlay.hidden = true
                })
            }
        }
    }
    
    override func viewDidLoad() {
        self.forceResignResponder = false
        
        // Adjust capture button layer so that it becomes rounded
        self.addButtonBkg.layer.cornerRadius = 40.0
        self.addButtonInnerView.layer.cornerRadius = 35
        self.addButtonInnerView.layer.borderWidth = 3
        self.addButtonInnerView.layer.borderColor = UIColor.blackColor().CGColor
        
        // Hide overlay view
        self.placeTitleOverlay.hidden = true
        
        
        self.placeBuilder = PlaceBuilder(didBuildPlace: { (place) -> Void in
            // save & return
            let realm = try! Realm()
            try! realm.write({ () -> Void in
                realm.add(place)
                self.performSegueWithIdentifier("unwind-add-place", sender: self)
            })
        })
        
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
            self.gpsSession?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.gpsSession?.distanceFilter = 2
            self.gpsSession?.getLocation({ (sender, location) -> Void in
                self.placeBuilder.location = location.coordinate
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) -> Void in
                    if let placemark = placeMarks?.first {
                        self.addressTextField.text = placemark.addressDictionary?["Street"] as? String
                        self.placeBuilder.address = placemark.addressDictionary
                    }
                })
            })
        }
    }
    
    @IBAction func retakePicture(sender:UIButton) {
        self.view.endEditing(true)
        self.overlayPlaceDataViewHidden = true;
    }
    
    @IBAction func porcodio(textfield:UITextField) {
        if let text = textfield.text {
            guard text.characters.count > 0 else {
                return
            }
            textfield.resignFirstResponder()
            self.placeBuilder.title = text
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
    }
    
    @IBAction func takePictureAction(sender:UIButton){
        self.addButtonInnerView.backgroundColor = UIColor.whiteColor()
        self.cameraCapture.currentSession?.captureFrame({ (imageData, error) -> Void in
            if imageData != nil {
                let imageUID = NSUUID().UUIDString
                writeDataInLibraryPath(imageData!, filename: imageUID)
                self.overlayPlaceDataViewHidden = false;
                self.placeBuilder.imageUID = imageUID
            }
        })
    }
}