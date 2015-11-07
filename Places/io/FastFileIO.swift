//
//  FastFileIO.swift
//  Places
//
//  Created by William Izzo on 29/10/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import Foundation

func writeDataInLibraryPath(data:NSData, filename:String) -> Bool {
    if let appDir = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true).first {
        let appLibUrl = NSURL(fileURLWithPath: appDir, isDirectory: true)
        let fullPathUrl = appLibUrl.URLByAppendingPathComponent(filename)
        
        return data.writeToURL(fullPathUrl, atomically: true)
    }
    
    return false
}

func readDataInLibraryPath(filename:String) -> NSData? {
    if let appDir = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true).first {
        let appLibUrl = NSURL(fileURLWithPath: appDir, isDirectory: true)
        let fullPathUrl = appLibUrl.URLByAppendingPathComponent(filename)
        
        return NSData(contentsOfURL: fullPathUrl)
    }
    
    return nil
}