//
//  CameraCaputreLayer.swift
//  Places
//
//  Created by William Izzo on 28/10/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

typealias cameraCaptureSessionDidStart = (session:CameraCaptureSession)->Void
typealias cameraCaptureDidCaptureStillImage = (image:UIImage?, error:NSError?) -> Void

class CameraCaptureSession {

    private var __previewLayer : AVCaptureVideoPreviewLayer?
    
    func captureFrame(didCapture:cameraCaptureDidCaptureStillImage) {
        guard self.session.running == true else {
            didCapture(image: nil, error: nil)
            return
        }
        
        let stillOutput = self.session.outputs.first as? AVCaptureStillImageOutput
        let connection = stillOutput?.connectionWithMediaType(AVMediaTypeVideo)
        
        stillOutput?.captureStillImageAsynchronouslyFromConnection(connection,
            completionHandler: { (samplerBuffer, error) -> Void in
                guard error == nil else {
                    didCapture(image:nil, error:error)
                    return
                }
                
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(samplerBuffer)
                
                didCapture(image: UIImage(data: imageData), error: nil)
        })
    }
    
    private var session : AVCaptureSession
    
    private init(cameraSession:AVCaptureSession){
        self.session = cameraSession
    }
    
    deinit {
        self.stopSession()
    }
    
    private func activateSession( didStart:cameraCaptureSessionDidStart ) {
        // TODO this should be running in a background thread.
        self.session.startRunning()

        didStart(session:self)
    }
    
    func previewLayer () -> AVCaptureVideoPreviewLayer? {
        guard self.session.running == true else {
            return nil
        }
        self.__previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        return self.__previewLayer
    }
    
    private func stopSession() {
        self.__previewLayer?.removeFromSuperlayer()
        self.session.stopRunning()
    }
}

typealias CameraCaptureDidBeginSession = (session:CameraCaptureSession?) -> Void

class CameraCapture  {
    enum CameraCaptureSessionType {
        case FrontCamera
        case BackCamera
    }
    
    private var frontSession : CameraCaptureSession?
    private var backSession : CameraCaptureSession?
    
    private weak var currentSession : CameraCaptureSession? = nil
    
    private init(frontCameraSession:CameraCaptureSession?, backCameraSession:CameraCaptureSession?){
        self.frontSession = frontCameraSession
        self.backSession = backCameraSession
    }
    
    func beginSession(type:CameraCaptureSessionType, didBegin:CameraCaptureDidBeginSession) {
        if self.currentSession != nil {
            self.currentSession?.stopSession()
        }
        
        switch type {
        case .FrontCamera:
            self.currentSession = self.frontSession
        case .BackCamera:
            self.currentSession = self.backSession
        }
        
        guard self.currentSession != nil else {
            didBegin(session: nil)
            return
        }
        
        self.currentSession?.activateSession({ (session) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                didBegin(session: session)
            })
            
        })
    }
    
    func stopCurrentSession(){
        
    }
}

typealias cameraCaptureSessionBuilt = (session:CameraCapture?) -> Void
class CameraCaptureBuilder {
    static func build(completion:cameraCaptureSessionBuilt) {
        let auth = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch auth {
        case .NotDetermined:
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                completionHandler: { (granted) -> Void in
                    guard granted == true else {
                        completion(session:nil)
                        return;
                    }
                    completion(session:CameraCaptureBuilder.buildSession())
            })
        case .Authorized:
            return completion(session:CameraCaptureBuilder.buildSession())
        default:
            return completion(session: nil)
        }
    }
    
    
    private static func buildSession() -> CameraCapture {
        // Find front & back camera
        var backCameraDevice : AVCaptureDevice?
        var frontCameraDevice : AVCaptureDevice?
        var frontCameraSession : AVCaptureSession?
        var backCameraSession : AVCaptureSession?
        
        let availableCameraDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for device in availableCameraDevices as! [AVCaptureDevice] {
            if device.position == .Back {
                backCameraDevice = device
            }
            else if device.position == .Front {
                frontCameraDevice = device
            }
        }
        
        if backCameraDevice != nil {
            let backCameraInput = try! AVCaptureDeviceInput(device:backCameraDevice!)
            backCameraSession = AVCaptureSession()
            backCameraSession?.addInput(backCameraInput)
            backCameraSession?.addOutput(AVCaptureStillImageOutput())
            backCameraSession?.sessionPreset = AVCaptureSessionPresetPhoto
        }
        
        if frontCameraDevice != nil {
            let frontCameraInput = try! AVCaptureDeviceInput(device:frontCameraDevice!)
            frontCameraSession = AVCaptureSession()
            frontCameraSession?.addInput(frontCameraInput)
            frontCameraSession?.addOutput(AVCaptureStillImageOutput())
            frontCameraSession?.sessionPreset = AVCaptureSessionPresetPhoto
        }
        
        return CameraCapture(
            frontCameraSession: CameraCaptureSession(cameraSession: frontCameraSession!),
            backCameraSession: CameraCaptureSession(cameraSession: backCameraSession!)
        )
        
    }
}