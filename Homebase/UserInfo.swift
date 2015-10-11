//
//  UserInfo.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

class UserInfo: UIViewController {
    
    let ref = Firebase(url: "https://homebasehack.firebaseio.com")
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBAction func addInfo(sender: AnyObject) {
        if (lastName.text != "" && firstName.text != "") {
            
            
        self.ref.childByAppendingPath("users")
                .childByAppendingPath(ref.authData.uid).childByAppendingPath("lastName").setValue(lastName.text)
            self.ref.childByAppendingPath("users")
                .childByAppendingPath(ref.authData.uid).childByAppendingPath("firstName").setValue(firstName.text)
            self.ref.childByAppendingPath("users")
                .childByAppendingPath(ref.authData.uid).childByAppendingPath("fullName").setValue(firstName.text! + " " + lastName.text!)
            NSUserDefaults.standardUserDefaults().setValue(self.firstName.text! + " " + self.lastName.text!, forKey: "fullName")
            NSUserDefaults.standardUserDefaults().setValue("https://homebasehack.firebaseio.com/"+ref.authData.uid, forKey: "userData")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        self.performSegueWithIdentifier("gohome", sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
