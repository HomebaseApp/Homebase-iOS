//
//  LogInViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase


class LogInViewController: UIViewController {
    
    // get server object
    let server = Firebase(url: "https://homebasehack.firebaseio.com")
    let MyKeychainWrapper = KeychainWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check for Firebase login info
        //      fname
        //      lname

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func nextField(sender: AnyObject) {
        passwordField.becomeFirstResponder()
    }
    // submit information
    @IBAction func submit(sender: AnyObject) {
        // obvious invalid data shows alert, doesnt log in
        if (emailField.text == "" || passwordField.text == "" || emailField.text?.containsString("@") == false)  {
            let alertView = UIAlertController(title: "Error",
                message: "Invalid Login" as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Try again", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return;
        }
        
        // check login data against firebase
        server.authUser(emailField.text, password: passwordField.text) {
            error, authData in
            if error != nil {
                var errorText: String = "Something went wrong"
                
                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    switch (errorCode) {
                    case .UserDoesNotExist:
                        errorText = "Invalid Username"
                        print("Handle invalid user")
                    case .InvalidEmail:
                        errorText = "Invalid Email"
                        print("Handle invalid email")
                    case .InvalidPassword:
                        errorText = "Invalid Password"
                        print("Handle invalid password")
                    default:
                        errorText = "Something went wrong"
                        print("Handle default situation")
                    }
                }
                
                // let them know
                let alertView = UIAlertController(title: "Error",
                    message: errorText as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "Try again", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                
            } else {
                // user is logged in, check authData for data
                
                
                //save password in Keychain
                self.MyKeychainWrapper.mySetObject(self.passwordField.text, forKey:kSecValueData)
                self.MyKeychainWrapper.writeToKeychain()
                
                //save data locally
                NSUserDefaults.standardUserDefaults().setValue(self.emailField.text, forKey: "email")
                NSUserDefaults.standardUserDefaults().synchronize()

                
                if (false) {
                    //if in a homebase, go home
                    self.performSegueWithIdentifier("goodLogin", sender: nil)
                } else {
                    // else force join one
                    self.performSegueWithIdentifier("noHomeBase", sender: nil)
                }
            }
        }

    }
    // background taps dismiss keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "getMoreInfo"){ //pass forward filled data
            let info = segue.destinationViewController as! gatherInfoViewController
            info.holdPass = passwordField.text!
            info.holdEmail = emailField.text!
        }
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
