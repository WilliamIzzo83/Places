//
//  AppDelegate.swift
//  Places
//
//  Created by William Izzo on 26/10/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let realmConfiguration = Realm.Configuration(
            schemaVersion : 1,
            migrationBlock : { migration, oldSchemaVersion in
                
        })
        
        Realm.Configuration.defaultConfiguration = realmConfiguration
        
        
        return true
    }

    

    

}

