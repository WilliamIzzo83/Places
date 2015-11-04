//
//  Gps.swift
//  Places
//
//  Created by William Izzo on 04/11/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import UIKit
import CoreLocation

typealias requestLocationReady = (location:CLLocation) -> Void

class GpsSingleLocationSession : NSObject, CLLocationManagerDelegate {
    private lazy var locationManager : CLLocationManager = CLLocationManager()
    public var desiredAccuracy : CLLocationAccuracy = kCLLocationAccuracyHundredMeters
    public var distanceFilter : CLLocationDistance = 10.0
    private var requestListener : requestLocationReady?
    private init() {

    }
    
    private init(requestLocationListener:requestLocationReady) {
        self.requestLocationListener = requestLocationListener
    }
    
    public requestLocation() {

    }
}

class GpsUpdateLocationSession : NSObject, CLLocationManagerDelegate {
    private lazy var locationManager : CLLocationManager!
}

class Gps {
    static func singleLocationSession() -> GpsSingleLocationSession? {
        return nil
    }
    
    static func updateLocationSession(requiredAuthorization:CLAuthorizationStatus) -> GpsUpdateLocationSession? {
        return nil
    }
}
