//
//  SettingsView.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

class SettingsView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var user_Name: UINavigationItem!
    
    @IBOutlet weak var homeBase: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userData = NSUserDefaults.standardUserDefaults().valueForKey("userData") as! Dictionary<String, String>
        
        user_Name.title = userData["fullName"]
        // Do any additional setup after loading the view.
        
        homeBase.text = userData["homebase"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(sender: AnyObject) {
        server.ref().unauth()
        
        //DELETE INFORMATION FROM SHARED DATA
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userData")
        print("Deleted local userData")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.performSegueWithIdentifier("logOut", sender: nil)
        
    }
    
    @IBAction func randomTheme(sender: AnyObject) {
        let navController = self.navigationController as! colorfulNavigationController
        navController.generateAppTheme()
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
