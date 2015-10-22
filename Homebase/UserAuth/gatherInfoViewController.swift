//
//  gatherInfoViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase
import Parse

class gatherInfoViewController: UIViewController, UIAlertViewDelegate {
    
    let MyKeychainWrapper = KeychainWrapper()

    var holdPass: String = ""
    var holdEmail:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text=holdEmail
        passwordField.text=holdPass

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var lastField: UITextField!
    
    @IBAction func nextField(sender: AnyObject) { // handle text inputs
        if (sender.tag == 1){
            passwordField.becomeFirstResponder()
        } else if (sender.tag == 2){
            firstField.becomeFirstResponder()
        } else if (sender.tag == 3){
            lastField.becomeFirstResponder()
        }
    }
    

    @IBAction func joinHomebase(sender: AnyObject) {
        
        if !validInput() {
            displayBasicAlert("Invalid Input", error: "All Fields Are Required", buttonText: "Try Again")
            return
        }
        
     
        var user = PFUser()
        user.username = emailField.text!
        user.password = passwordField.text!
        user.email = emailField.text!
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }
        
        
    }
    
    func validInput() -> Bool {
        
        if (
        self.lastField.text! == ""
        || self.firstField.text! == ""
        || self.passwordField.text! == ""
        || self.emailField.text! == "")
        {
            return false
        } else{
            return true
        }
    }
    
    
    @IBAction func firebaseJoin(sender: AnyObject) {
        
        if (self.lastField.text! == "" || self.firstField.text! == "") {
            displayBasicAlert("Error", error: "Please fill in all fields", buttonText: "Try Again")
            return
        }
        
        
        
        // send data to Firebase
        server.ref().createUser(self.emailField.text!, password: self.passwordField.text!,
            withValueCompletionBlock: { error, result in
                
                if error != nil {
                    
                    print(self.emailField.text!)
                    // There was an error creating the account
                    
                    // Something went wrong. :( determin problem
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
                    let uid = result["uid"] as? String
                    // account creation just completed successfully :)
                    
                    // The logged in user's unique identifier
                    print("User created with UID: " + uid!)
                    self.logIn()
                }
                
                
        })
        
    }
    
    func logIn(){
        server.ref().authUser(self.emailField.text!, password:self.passwordField.text!) {
            error, authData in
            if error != nil {
                // Something went wrong. :( determin problem
                
                // let them know
                let alertView = UIAlertController(title: "Account created",
                    message: "However Login failed" as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    self.performSegueWithIdentifier("returnLogin", sender: nil)
                    
                }
                alertView.addAction(okAction)
                
                self.presentViewController(alertView, animated: true, completion: nil)
            } else {
                // Authentication just completed successfully :)
                
                let newUser = [
                    "provider": authData.provider,
                    "firstName": self.firstField.text,
                    "lastName": self.lastField.text,
                    "fullName": self.firstField.text! + " " + self.lastField.text!,
                    "email": self.emailField.text!
                ]
                print(newUser)
                
                // The logged in user's unique identifier
                print("Working with: " +  authData.uid!)
                                
                // Create a new user dictionary accessing the user's info
                // provided by the authData parameter

                
                // Create a child path with a key set to the uid underneath the "users" node
                server.userData().setValue(newUser)
                //self.server.childByAppendingPath("test").setValue(newUser)
                
                //save password in Keychain
                self.MyKeychainWrapper.mySetObject(self.passwordField.text, forKey:kSecValueData)
                self.MyKeychainWrapper.writeToKeychain()
                
                // save user email in device
                
                NSUserDefaults.standardUserDefaults().setValue(newUser, forKey: "userData")
                
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let alertView = UIAlertController(title: "Account Created!",
                    message: "" as String, preferredStyle:.Alert)
                let newAccountAction = UIAlertAction(title: "Awesome!", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    self.performSegueWithIdentifier("homebase", sender: nil)
                }
                alertView.addAction(newAccountAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                
            }
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
