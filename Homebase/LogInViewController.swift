//
//  LogInViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase
import Parse


class LogInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func nextField(sender: AnyObject) {
        passwordField.becomeFirstResponder()
    }
    
    // submit information
    @IBAction func submit(sender: AnyObject) {
        
        loginLoading(true)
        
        if !validInput() { //if input is invalid
            loginLoading(false)
            displayBasicAlert("Error", error: "Invalid Login", buttonText: "Try Again")
            return //dont send it, let them fix it first
        }
        
        if loginParse(usernameField.text!, password: passwordField.text!) { // try to login and if it succeeds
            //switch to homepage
            
        }

    }
    
    func loginLoading(showIndicator: Bool){
        if showIndicator {
            loadingIndicator.hidden = false
            loginButton.hidden = true
        } else {
            loadingIndicator.hidden = true
            loginButton.hidden = false
        }
    }
    
    func validInput() -> Bool {
        //checks for obvious signs of invalid input
        if (usernameField.text == ""
            || passwordField.text == "") {
            return false
        }
        return true
    }
    
    func loginParse(username: String, password: String) -> Bool{
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
            } else {
                // The login failed. Check error to see why.
            }
        }
        return false
    }
    
    func firebaseSubmit(){
        // check login data against firebase
        server.ref().authUser(usernameField.text, password: passwordField.text) {
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
                self.displayBasicAlert("Error", error: errorText, buttonText: "Try Again")
                
            } else {
                // user is logged in, check authData for data
                
                // save inputted data locally
                var localData = [
                    "email": self.usernameField.text,
                    "uid": server.ref().authData.uid
                ]
                print("email Saved Locally")
                print("UID Saved Locally")
                
                //save most recent server data locally
                server.userData().observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    if snapshot.exists() { //check if it has data
                        
                        
                        
                        if snapshot.hasChild("fullName") {
                            let fullName = snapshot.value.objectForKey("fullName") as! String
                            localData["fullName"] = fullName
                            print("Full Name Saved Locally")
                        }
                        if snapshot.hasChild("firstName") {
                            let firstName = snapshot.value.objectForKey("firstName") as! String
                            localData["firstName"] = firstName
                            print("First Name Saved Locally")
                        }
                        if snapshot.hasChild("lastName") {
                            let lastName = snapshot.value.objectForKey("lastName") as! String
                            localData["lastName"] = lastName
                            print("Last Name Saved Locally")
                        }
                        if snapshot.hasChild("homebase") {
                            let homebase = snapshot.value.objectForKey("homebase") as! String
                            localData["homebase"] = homebase
                            print("Joined Homebase: " + localData["homebase"]!)
                            print("HomeBase Saved Locally")
                        }
                        if snapshot.hasChild("provider") {
                            let provider = snapshot.value.objectForKey("provider") as! String
                            localData["provider"] = provider
                            print("Authentication Provider Saved Locally")
                        }
                        
                        NSUserDefaults.standardUserDefaults().setValue(localData, forKey: "userData")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                    } // even if snapshot does not have data
                    
                    // if user has not selected a Homebase, force to selection screen
                    if ( NSUserDefaults.standardUserDefaults().valueForKeyPath("userData/homebase") != nil) {
                        //if in a homebase, go home
                        print("Homebase selected, going home")
                        self.performSegueWithIdentifier("goodLogin", sender: nil)
                    } else {
                        // else force join one
                        print("Homebase NOT selected, select one now")
                        self.performSegueWithIdentifier("noHomeBase", sender: nil)
                    }
                    
                })
                
                
                
                NSUserDefaults.standardUserDefaults().synchronize()
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
            info.holdUsername = usernameField.text!
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
