//
//  SettingsView.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Parse

class SettingsView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var user_Name: UINavigationItem!
    
    @IBOutlet weak var homeBase: UILabel!

    @IBOutlet weak var switchHomebase: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userHomebase = user()?.homebase {
            user_Name.title = user()?.fullName
            
            userHomebase.fetchIfNeededInBackgroundWithBlock({
                (result, error) -> Void in
                if error == nil {
                    let homebase = result as! Homebase
                    self.homeBase.text = homebase.name
                    self.loadingIndicator.stopAnimating()
                    self.homeBase.hidden = false
                    self.switchHomebase.hidden = false
                }
            })
        }
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
