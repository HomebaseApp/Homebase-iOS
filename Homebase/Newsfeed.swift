//
//  Newsfeed.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

class Newsfeed: UITableViewController {
    
    //var postCount:UInt = 0
    
    let userData = NSUserDefaults.standardUserDefaults().valueForKey("userData") as! Dictionary<String, String>
    let homebaseURL = NSUserDefaults.standardUserDefaults().valueForKeyPath("url/homebase") as! String
        
    var broadcasts:Firebase = Firebase()

    var posts: [Dictionary<String, String>] = []
    
    let postCellIdentifier = "broadcast"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        broadcasts = Firebase(url: homebaseURL + "/broadcasts")
                
        broadcasts.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot: FDataSnapshot!) in
            
            self.posts.append(snapshot.value as! Dictionary)
            self.tableView.reloadData()

        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // section 1: Create new Post
        // section 2: posts
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            return 1
        } else {
            return Int(posts.count)
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("newPost") as! NewPostCell
            cell.textLabel?.text = "New Broadcast"
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            return cell
        }
        return postCellAtIndexPath(indexPath)
    }
    
    func postCellAtIndexPath(indexPath:NSIndexPath) -> Postcell {
        let cell = tableView.dequeueReusableCellWithIdentifier(postCellIdentifier) as! Postcell
        setNameForCell(cell, indexPath: indexPath)
        setTextForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setNameForCell(cell:Postcell, indexPath:NSIndexPath) {
        cell.nameButton.setTitle(posts[(posts.count - 1) - (indexPath.item)]["fullName"]!, forState: UIControlState.Normal)
        //
        if posts[(posts.count - 1) - (indexPath.item)]["uid"] != nil {
            cell.posterID = posts[(posts.count - 1) - (indexPath.item)]["uid"]!
        }
    }
  
    
    
    func setTextForCell(cell:Postcell, indexPath:NSIndexPath) {
        cell.postText.text = posts[(posts.count - 1) - (indexPath.item)]["text"]!
    
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

    
    // MARK: - Navigation
    
    let viewPostSegueIdentifier = "viewPost"

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == viewPostSegueIdentifier {
            if let destination = segue.destinationViewController as? ViewPost {
                if let postIndex = tableView.indexPathForSelectedRow?.row {
                    var postedID: String = ""
                    if posts[posts.count - (postIndex)]["uid"] != nil {
                        postedID = posts[posts.count - (postIndex)]["uid"]!
                    }
                    
                    destination.thePost = PostData(
                        posterID: postedID,
                        posterFullName: posts[posts.count - (postIndex)]["fullName"]!,
                        postText: posts[posts.count - (postIndex)]["text"]!
                    )
                }
            }
        }
    }
    

}
