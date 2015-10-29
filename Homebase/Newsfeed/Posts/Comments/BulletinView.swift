//
//  ViewPost.swift
//  Homebase
//
//  Shows a selected post and its comments
//
//  Created by Justin Oroz on 10/14/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BulletinView: PFQueryTableViewController {
    
    var theBulletin = Bulletin()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parseClassName = "Comment"
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 { //post section only has 1
            return 2
        } else {
            return objects!.count
        }
    }

    
    // https://parse.com/questions/using-pfquerytableviewcontroller-for-uitableview-sections
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Comment")
        
        query.whereKey("homebase", equalTo: (user()?.homebase)!)
        query.whereKey("bulletin", equalTo: theBulletin)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("theBulletin", forIndexPath: indexPath) as! BulletinCell
                cell.nameButton.setTitle(theBulletin.user.fullName, forState: UIControlState.Normal)
                cell.postText.text = theBulletin.text
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("newComment", forIndexPath: indexPath)
                cell.textLabel?.text = "New Comment"
                return cell
            }

        } else {
            return commentCellAtIndexPath(indexPath)
        }

    }
    
    let commentCellIdentifier = "theComments"
    
    func commentCellAtIndexPath(indexPath:NSIndexPath) -> CommentCell {
        let theComment = objects![indexPath.row] as! Comment
        let cell = tableView.dequeueReusableCellWithIdentifier(commentCellIdentifier) as! CommentCell
        
        cell.nameButton.setTitle(theComment.user.fullName, forState: .Normal)
        cell.commentLabel.text = theComment.text
        cell.commentLabel.sizeToFit()

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return heightForCell(theBulletin.text, lines: 0,font: UIFont.systemFontOfSize(17.0), width: self.tableView.bounds.width - 22) + 60
            } else {
                return 45.0
            }
        } else {
            let theComment = objects![indexPath.row] as! Comment
            return heightForCell(theComment.text,
                lines: 0,font: UIFont.systemFontOfSize(16.0),
                width: self.tableView.bounds.width - 22) + 60
        }
    }
    
    func heightForCell(text:String, lines: Int ,font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = lines
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
        if self.tableView.indexPathForSelectedRow?.section == 0
            && self.tableView.indexPathForSelectedRow?.row == 1 {
            let newCommentView = segue.destinationViewController as! NewCommentView
            newCommentView.theBulletin = theBulletin
        }
    }
    

}
