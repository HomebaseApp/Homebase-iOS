//
//  homebaseSelectionViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

class homebaseSelectionViewController: UIViewController {
    
    let users = Firebase(url: "https://homebasehack.firebaseio.com/users/")

    let homebases = Firebase(url: "https://homebasehack.firebaseio.com/bases/")

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var homebaseField: UITextField!

    @IBAction func joinHomeBase(sender: AnyObject) {
        
        // homebase cant be empty
        if(homebaseField.text == "") {
            let alertView = UIAlertController(title: "Error",
                message: "Enter a name" as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        
        
        //save homebase name in info on firebase
        users.childByAppendingPath(users.authData.uid).childByAppendingPath("homebase").setValue(homebaseField.text)
        
        //save the homebase info to local storage
        NSUserDefaults.standardUserDefaults().setValue(homebaseField.text, forKey: "homebase")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.performSegueWithIdentifier("finishSignup", sender: nil)
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
