//
//  Gps.swift
//  Places
//
//  Created by William Izzo on 04/11/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import UIKit
import CoreLocation

private typealias requestLocationReady = (sender:GpsReactiveLocationManager, location:CLLocation) -> Void
private typealias authorizationChanged = (sender:GpsReactiveLocationManager, authorization:CLAuthorizationStatus) -> Void

private class GpsReactiveLocationManager : NSObject, CLLocationManagerDelegate {
    private lazy var locationManager : CLLocationManager = CLLocationManager()
    private var locationReadyListener : requestLocationReady!
    private var authChangedListener : authorizationChanged!
    
    var distanceFilter : CLLocationDistance {
        get {
            return self.locationManager.distanceFilter
        }
        
        set(value) {
            self.locationManager.distanceFilter = value
        }
    }
    
    var desiredAccuracy : CLLocationAccuracy {
        get {
            return self.locationManager.desiredAccuracy
        }
        
        set(value) {
            self.locationManager.desiredAccuracy = value
        }
    }
    

    
    func registerAuthChangedListener(authorizationChangedListener:authorizationChanged){
        self.authChangedListener = authorizationChangedListener
    }
    
    func registerLocationUpdateListener(locationUpdateListener:requestLocationReady){
        self.locationReadyListener = locationUpdateListener
    }
    
    func requestAlwaysAuthorization(){
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func requestWhenInUseAuthorization(){
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        self.locationManager.delegate = self
        self.locationManager.requestLocation()
    }
    
    
    func startUpdatingLocation(){
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation(){
        self.locationManager.delegate = self
        self.locationManager.stopUpdatingLocation()
    }
    
    @objc func locationManager(manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
            if let nearestLocation = locations.first {
                self.locationReadyListener(sender:self, location: nearestLocation)
            }
    }
    
    @objc
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.authChangedListener(sender:self, authorization: status)
    }
    
    @objc
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("failed")
    }
}



class GpsSingleLocationSession {
    typealias didUpdateLocationListener = (sender:GpsSingleLocationSession, location:CLLocation) -> Void
    
    private var reactiveLocationManager = GpsReactiveLocationManager()

    
    private init(){
        self.reactiveLocationManager.registerAuthChangedListener {
            (sender, authorization) -> Void in
            
        }
    }
    
    func getLocation(listener:didUpdateLocationListener){
        self.reactiveLocationManager.registerLocationUpdateListener {
            (sender, location) -> Void in
            listener(sender: self, location: location)
        }
        
        self.reactiveLocationManager.requestLocation()
    }
}


enum GpsAuthorizationRequired : Int32 {
    case Always
    case WhenInUse
}

class Gps {
    
    private static let authorizingLocationManager = GpsReactiveLocationManager()
    private static func requestCLAuth(wantedAuth:GpsAuthorizationRequired, callback:(authOk:Bool) -> Void) {
        

        authorizingLocationManager.registerAuthChangedListener { (sender, authorization) -> Void in
            
            if authorization == .Restricted || authorization == .Denied {
                callback(authOk: false)
                return
            }
            
            callback(authOk: true)
            return
        }
        
        switch wantedAuth {
        case .WhenInUse:
            authorizingLocationManager.requestWhenInUseAuthorization()
        case .Always:
            authorizingLocationManager.requestAlwaysAuthorization()
        }
        
    }
    
    
    static func singleLocationSession(requiredAuth:GpsAuthorizationRequired, sessionReady: (session:GpsSingleLocationSession?) -> Void) -> Void {
        
        let currentState = CLLocationManager.authorizationStatus()
        switch currentState {
        case .NotDetermined:
            self.requestCLAuth(requiredAuth, callback: { (authOk) -> Void in
                guard authOk == true else {
                    sessionReady(session: nil)
                    return
                }
                
                sessionReady(session: GpsSingleLocationSession())
            })
        case .Denied, .Restricted:
            sessionReady(session: nil)
        
        default:
            sessionReady(session: GpsSingleLocationSession())
        }
    }
}
