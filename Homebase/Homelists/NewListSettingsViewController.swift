//
//  NewListSettingsViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/29/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Parse

class NewListSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var users: [HomebaseUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        queryForData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func queryForData(){
        let query = HomebaseUser.query()
        
        query?.whereKey("homebase", equalTo: (user()?.homebase)!)
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                self.users = objects as! [HomebaseUser]
                // refresh tableview
                self.tableView.reloadData()
            } else {
                print("error retrieving users in homebase: " + error!.description)
            }
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = users[indexPath.row].fullName
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
