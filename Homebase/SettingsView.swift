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
    
    @IBOutlet weak var test: UINavigationItem!
    
    let ref = Firebase(url: "https://homebasehack.firebaseio.com")
    
    var baseRef = Firebase(url: "https://homebasehack.firebaseio.com")
    
    @IBOutlet weak var homebaseField: UITextField!
    @IBAction func joinHomeBase(sender: AnyObject) {
        
        if self.homebaseField.text != "" {
            
            NSUserDefaults.standardUserDefaults().setValue(self.homebaseField.text, forKey: "homebase")
            
            self.ref.childByAppendingPath("bases")
                .childByAppendingPath(self.homebaseField.text).childByAppendingPath("users").childByAppendingPath(ref.authData.uid).setValue(NSUserDefaults.standardUserDefaults().dataForKey("fullName"))
            
            baseRef = Firebase(url: "https://homebasehack.firebaseio.com/bases/")
            NSUserDefaults.standardUserDefaults().setValue("https://homebasehack.firebaseio.com/bases/"+self.homebaseField.text!, forKey: "homebaseURL")
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        
        
        
        
    }
    
    @IBOutlet weak var tester: UIButton!
    
    @IBAction func logOut(sender: AnyObject) {
        ref.unauth()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test.title = NSUserDefaults.standardUserDefaults().valueForKey("fullName") as? String
        // Do any additional setup after loading the view.
        
        //tester.setTitle("Hello World!!", forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
