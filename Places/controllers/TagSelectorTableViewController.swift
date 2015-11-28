//
//  TagSelectorTableViewController.swift
//  Places
//
//  Created by William Izzo on 28/11/15.
//  Copyright © 2015 wizzo s.l.d.s. All rights reserved.
//

import UIKit
import RealmSwift

class TagSelectorTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var availableTags : Results<Tag>!
    var place : Place!
    var realm : Realm!
    
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.realm = try! Realm()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.availableTags = self.realm.objects(Tag)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    private func placeHasTag(tag:Tag) -> Bool {
        return self.place.tags.contains { (placeTag) -> Bool in
            return placeTag.uuid == tag.uuid
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableTags.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tag-tvr", forIndexPath: indexPath)

        // Configure the cell...
        let tag = self.availableTags[indexPath.row]
        cell.textLabel?.text = tag.name
        
        if self.placeHasTag(tag) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedTag = self.availableTags[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
        
        try! self.realm.write({ () -> Void in
            if self.placeHasTag(selectedTag) {
                if let tagIndex = self.place.tags.indexOf(selectedTag) {
                    self.place.tags.removeAtIndex(tagIndex)
                    cell?.accessoryType = UITableViewCellAccessoryType.None
                }
            } else {
                self.place.tags.append(selectedTag)
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        })
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
