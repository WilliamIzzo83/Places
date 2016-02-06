//
//  PlacesListViewController.swift
//  Places
//
//  Created by William Izzo on 27/10/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import CoreLocation

class PlacesListViewController : UITableViewController {
    var availablePlaces : Results<Place>!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(
            nil,
            forBarMetrics: UIBarMetrics.Default)
        
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.view.backgroundColor = nil
        self.navigationController?.navigationBar.shadowImage = nil
        
        
        
        let realm = try! Realm()
        self.availablePlaces = realm.objects(Place).sorted("timestamp", ascending: true)
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availablePlaces.count
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("place-tvr", forIndexPath: indexPath);
            
            if let placeTVR = cell as? PlaceTVR {
                let place = self.availablePlaces[indexPath.row]
                placeTVR.titleLabel.text = place.title
                placeTVR.addressLabel.text = place.longAddress
                placeTVR.scrimView.gradientColors = [
                    UIColor(white: 0.0, alpha: 0.0),
                    UIColor(white: 0.0, alpha: 0.4),
                ]
                
                let imageUID = place.imageUID
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                    if let imageData = readDataInLibraryPath(imageUID) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            placeTVR.placeImage.image = UIImage(data: imageData)
                        })
                    }
                }
                
                
            }
            
            return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail_segue" {
            let detailController = segue.destinationViewController as! DetailViewController
            if let selectedRowIPath = self.tableView.indexPathForSelectedRow {
                detailController.place = self.availablePlaces[selectedRowIPath.row]
            }
        }
    }
    
    override func tableView(
        tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func erasePlace(place:Place, indexPath:NSIndexPath) {
        let alertController = UIAlertController(
            title: nil,
            message: "Erase place?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(
            UIAlertAction(
                title: "erase",
                style: UIAlertActionStyle.Destructive,
                handler: { (action) -> Void in
                    let realm = try! Realm()
                    try! realm.write({ () -> Void in
                        realm.delete(place)
                        
                        self.availablePlaces = realm.objects(Place)
                        
                        self.tableView.beginUpdates()
                        self.tableView.deleteRowsAtIndexPaths(
                            [indexPath],
                            withRowAnimation: UITableViewRowAnimation.None)
                        self.tableView.endUpdates()
                    })
                }
            )
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "cancel",
                style: UIAlertActionStyle.Cancel,
                handler: nil
            )
        )
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}