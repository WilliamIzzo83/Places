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
            schemaVersion : 3,
            migrationBlock : { migration, oldSchemaVersion in
                
        })
        
        Realm.Configuration.defaultConfiguration = realmConfiguration
        
        let realm = try! Realm()
        
        
        let availableTags = realm.objects(Tag)
        if availableTags.count == 0 {
        
            // build tags
            let bar = Tag()
            let vendingMachine = Tag()
            let club = Tag()
            let shop = Tag()
            let friendlyPlace = Tag()
            let work = Tag()
            let rest = Tag()
            let hotel = Tag()
            
            bar.name = "Bar"
            bar.uuid = NSUUID().UUIDString
            
            vendingMachine.name = "Vending machine"
            vendingMachine.uuid = NSUUID().UUIDString
            
            club.name = "Club"
            club.uuid = NSUUID().UUIDString
            
            shop.name = "Shop"
            shop.uuid = NSUUID().UUIDString
            
            friendlyPlace.name = "Friendly place"
            friendlyPlace.uuid = NSUUID().UUIDString
            
            work.name = "Work"
            work.uuid = NSUUID().UUIDString
            
            rest.name = "Restaurant"
            rest.uuid = NSUUID().UUIDString
            
            hotel.name = "Hotel"
            hotel.uuid = NSUUID().UUIDString
            
            try! realm.write({ () -> Void in
                realm.add(bar)
                realm.add(vendingMachine)
                realm.add(club)
                realm.add(shop)
                realm.add(friendlyPlace)
                realm.add(work)
                realm.add(rest)
                realm.add(hotel)
            })
        }
        
        return true
    }

    

    

}

