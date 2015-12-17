//
//  Place.swift
//  Places
//
//  Created by William Izzo on 27/10/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import Foundation
import RealmSwift

class Place: Object {
    dynamic var imageUID = ""
    dynamic var title = ""
    dynamic var address = ""
    dynamic var notes = ""
    dynamic var rating = 0
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    dynamic var shortAddress : String?
    dynamic var longAddress : String?
    dynamic var addressData : NSData?
    dynamic var timestamp : Double = NSDate().timeIntervalSinceReferenceDate
    let tags = List<Tag>()
}

class Tag : Object {
    dynamic var name = ""
    dynamic var uuid = ""
    
    override class func primaryKey() -> String {
        return "uuid"
    }
}