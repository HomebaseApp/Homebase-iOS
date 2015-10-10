//
//  LogIn.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

class LogIn: UIViewController {

    let MyKeychainWrapper = KeychainWrapper()

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var LogInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func enterPassword(sender: AnyObject) {
        passwordField.becomeFirstResponder()
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        if (emailField.text == "" || passwordField.text == "" || emailField.text?.containsString("@") == false)  {
            let alertView = UIAlertController(title: "Login Problem",
                message: "Wrong username or password." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return;
        }
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        
        
        let ref = Firebase(url: "https://homebasehack.firebaseio.com")
        ref.authUser(emailField.text, password: passwordField.text,
            withCompletionBlock: { error, authData in
                
                if error != nil {
                    // There was an error logging in to this account
                    let alertView = UIAlertController(title: "Login Problem",
                        message: "Wrong username or password." as String, preferredStyle:.Alert)
                    let newAccountAction = UIAlertAction(title: "Forgot Password?", style: .Default, handler: nil)
                    alertView.addAction(newAccountAction)
                    
                    let okAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                    alertView.addAction(okAction)

                    self.presentViewController(alertView, animated: true, completion: nil)
                } else {
                    // We are now logged in
                    //save info in keychain.
                    
                }
        })
        
        /*
        if checkLogin(usernameTextField.text!, password: passwordTextField.text!) {
            performSegueWithIdentifier("dismissLogin", sender: self)
        } else {
            // 7.
            let alertView = UIAlertController(title: "Login Problem",
                message: "Wrong username or password." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Foiled Again!", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        } */
        
    }

    @IBAction func createAccount(sender: AnyObject) {
        let ref = Firebase(url: "https://homebasehack.firebaseio.com")
        ref.createUser(emailField.text, password: passwordField.text,
            withValueCompletionBlock: { error, result in
                
                if error != nil {
                    // There was an error creating the account
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                }
        })
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
