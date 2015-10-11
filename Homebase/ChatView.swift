//
//  ChatView.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import MMX

class ChatView: UITableViewController {

    let MyKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username =  NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let password = MyKeychainWrapper.myObjectForKey("v_Data") as? String
        
        let credential = NSURLCredential(user: username, password: password!, persistence: NSURLCredentialPersistence.None)
        
        if (!signIn(credential)){ //if cant sign in
            signUp(credential, displayName: NSUserDefaults.standardUserDefaults().valueForKey("fullName") as! String) // try signing up
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func signIn(credential: NSURLCredential) -> Bool{
        var success: Bool = false
        MMXUser.logInWithCredential(credential,
            success: { (user) -> Void in
                //You MUST call start when you are ready to start sending and receiving messages.
                //Login may not always be the best time to call it.
                //You need to be ready to handle incoming messages when calling the API
                MMX.start()
                print("Chat Logon Success")
                success = true
            },
            failure: { (error) -> Void in
                
                success = false
        })
        return success
    }
    
    func signUp(credential: NSURLCredential, displayName: String){
        let user = MMXUser()
        user.displayName = displayName
        user.registerWithCredential(credential,
            success: {
                print("Chat Sign up success")
            },
            failure: { (error) -> Void in
                // error.code == 409 if the user already exists
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
