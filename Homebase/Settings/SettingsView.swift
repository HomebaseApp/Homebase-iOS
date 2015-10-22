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
        
        user_Name.title = user()["fullName"] as! String
        // Do any additional setup after loading the view.
        
        homeBase.text = user()["homebase"] as! String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(sender: AnyObject) {
        
        //DELETE INFORMATION FROM SHARED DATA
        
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
