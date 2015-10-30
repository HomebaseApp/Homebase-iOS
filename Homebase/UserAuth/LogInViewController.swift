//
//  LogInViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Parse
import Bolts



class LogInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailField: FullLengthTextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordField: FullLengthTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
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
        
        loginParse(emailField.text!, password: passwordField.text!)

    }
    
    func loginLoading(showIndicator: Bool){
        if showIndicator {
            loadingIndicator.hidden = false
            loginButton.hidden = true
            signUpButton.hidden = true
            
        } else {
            loadingIndicator.hidden = true
            loginButton.hidden = false
            signUpButton.hidden = false
        }
    }
    
    func validInput() -> Bool {
        //checks for obvious signs of invalid input
        if (emailField.text == ""
            || passwordField.text == "") {
            return false
        }
        return true
    }
    
    func loginParse(username: String, password: String){
        HomebaseUser.logInWithUsernameInBackground(username, password: password) {
            (pfuser: PFUser?, error: NSError?) -> Void in
            let user = pfuser as! HomebaseUser?
            if user != nil {
                // Do stuff after successful login.
                print("Logged in")
                if user!.homebase != nil {
                    print("Homebase selected, going home")
                    self.performSegueWithIdentifier("goodLogin", sender: nil)
                } else {
                    // else force join one
                    print("Homebase NOT selected, select one now")
                    self.performSegueWithIdentifier("noHomeBase", sender: nil)
                }
            } else {
                // The login failed. Check error to see why.
                self.displayBasicAlert("Login Error", error: error!.userInfo["error"] as! String, buttonText: "OK")
                self.loginLoading(false)
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
