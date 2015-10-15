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
    
    let ref = Firebase(url: "https://homebasehack.firebaseio.com")
    
    var baseRef = Firebase(url: "https://homebasehack.firebaseio.com")
    

    
    @IBOutlet weak var tester: UIButton!
    
    @IBAction func logOut(sender: AnyObject) {
        ref.unauth()
        //DELETE INFORMATION FROM SHARED DATA
        NSUserDefaults.standardUserDefaults().removeObjectForKey("uid")
        print("UID Removed Locally")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("fullName")
        print("fullName Removed Locally")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("homebase")
        print("homebase Removed Locally")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("firstName")
        print("firstName Removed Locally")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("lastName")
        print("lastName Removed Locally")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("provider")
        print("provider Removed Locally")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.performSegueWithIdentifier("logOut", sender: nil)



    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user_Name.title = NSUserDefaults.standardUserDefaults().valueForKey("fullName") as? String
        // Do any additional setup after loading the view.
        
       homeBase.text = NSUserDefaults.standardUserDefaults().valueForKey("homebase") as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var homeBase: UILabel!
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
