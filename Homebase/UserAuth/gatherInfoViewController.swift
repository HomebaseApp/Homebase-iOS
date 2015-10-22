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
import Bolts


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
        
        self.loading(true)
     
        let newUser = PFUser()
        newUser.username = emailField.text!
        newUser.password = passwordField.text!
        newUser.email = emailField.text!
        
        newUser.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? String
                // Show the errorString somewhere and let the user try again.
                self.displayBasicAlert("Signup Error", error: errorString!, buttonText: "Try Again")
                self.loading(false)
                return
            } else {
                // Hooray! Let them use the app now.
                
                newUser["firstName"] = self.firstField.text
                newUser["lastName"] = self.lastField.text
                newUser["fullName"] = self.firstField.text! + " " +
                    self.lastField.text!
                newUser.saveInBackground()
                self.performSegueWithIdentifier("homebase", sender: nil)
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
    
    
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    func loading(showIndicator: Bool){
        if showIndicator {
            loadingIndicator.hidden = false
            joinButton.hidden = true
        } else {
            loadingIndicator.hidden = true
            joinButton.hidden = false
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
