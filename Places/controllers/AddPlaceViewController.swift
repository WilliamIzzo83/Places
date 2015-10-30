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

class AddPlaceViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var titleTextField : UITextField!
    @IBOutlet var placeTitleOverlay : UIView!
    @IBOutlet weak var addButtonBkg: UIView!
    @IBOutlet weak var addButtonInnerView: UIView!
    private var cameraCapture : CameraCapture!
    
    override func viewDidLoad() {
        CameraCaptureBuilder.build { (session) -> Void in
            
            self.titleTextField.becomeFirstResponder()
            
            self.addButtonBkg.layer.cornerRadius = 40.0
            self.addButtonInnerView.layer.cornerRadius = 35
            
            self.addButtonInnerView.layer.borderWidth = 3
            self.addButtonInnerView.layer.borderColor = UIColor.blackColor().CGColor
            
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
        if let text = textField.text {
            guard text.characters.count > 0 else {
                return false
            }
            return true
        }
        return false
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
        
        self.cameraCapture.currentSession?.captureFrame({ (imageData, error) -> Void in
            if imageData != nil {
                let imageUID = NSUUID().UUIDString
                writeDataInLibraryPath(imageData!, filename: imageUID)
                
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
                
                place.imageUID = imageUID
                
                let realm = try! Realm()
                try! realm.write({ () -> Void in
                    realm.add(place)
                    self.performSegueWithIdentifier("unwind-add-place", sender: self)
                })
            }
            
        })
        
        
    }
}