//
//  Newsfeed.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ChameleonFramework

class BulletinBoardView: PFQueryTableViewController, UITextViewDelegate {
    
    let bulletinCellIdentifier = "bulletin"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Bulletin"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            return Int(self.objects!.count)
        }
    }
    
    // https://parse.com/questions/using-pfquerytableviewcontroller-for-uitableview-sections
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Bulletin")
        
        query.whereKey("homebase", equalTo: (user()?.homebase)!)
        
        return query
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("newBulletinButton")
            cell!.textLabel?.text = "New Bulletin"
            cell!.textLabel?.textAlignment = NSTextAlignment.Center
            return cell!
        }
        
        return postCellAtIndexPath(indexPath)
    }
    
    func postCellAtIndexPath(indexPath:NSIndexPath) -> BulletinCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(bulletinCellIdentifier) as! BulletinCell
        let bulletins = objects as! [Bulletin]
        let thisBulletin = bulletins[indexPath.row]
        
        cell.nameButton.setTitle(thisBulletin.userFullName, forState: UIControlState.Normal)
        
        cell.postText.text = thisBulletin.text
        cell.postText.numberOfLines = 4
        cell.postText.sizeToFit()
        
        //cell.backgroundColor = colorTheme
        
        return cell
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 45.0
        } else {
            let bulletins = objects as! [Bulletin]
            let thisBulletin = bulletins[indexPath.row]
            
            return heightForCell(thisBulletin.text, font: UIFont.systemFontOfSize(17.0), width: self.tableView.bounds.width - 22) + 60
        }
    }
    
    func heightForCell(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 4
        label.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "bulletinDetail" {
            
            if let destination = segue.destinationViewController as? BulletinView {
                if let bulletinIndex = tableView.indexPathForSelectedRow?.row {
                    destination.theBulletin = objects![bulletinIndex] as! Bulletin
                }
            }
        }
    }
    

}
