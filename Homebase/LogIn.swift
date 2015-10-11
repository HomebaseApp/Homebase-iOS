//
//  LogIn.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase
import MMX
class LogIn: UIViewController, UIAlertViewDelegate {

    let ref = Firebase(url: "https://homebasehack.firebaseio.com")

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
        
        // check for obvious input errors
        if (emailField.text == "" || passwordField.text == "" || emailField.text?.containsString("@") == false)  {
            let alertView = UIAlertController(title: "Login Problem",
                message: "Wrong username or password." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return;
        }
        
        
        // dismiss keyboard
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        
        
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
                    
                    // Magnet Login
                    let credential = NSURLCredential(user: self.emailField.text!, password: self.passwordField.text!, persistence: .None)
                    
                    MMXUser.logInWithCredential(credential,
                        success: { (user) -> Void in
                            //You MUST call start when you are ready to start sending and receiving messages.
                            //Login may not always be the best time to call it.
                            //You need to be ready to handle incoming messages when calling the API
                            MMX.start()
                        }, 
                        failure: { (error) -> Void in
                            
                    })
                    
                    // We are now logged in
                    //save info in keychain.
                    NSUserDefaults.standardUserDefaults().setValue(self.ref.authData.uid, forKey: "uid")
                    NSUserDefaults.standardUserDefaults().setValue("https://homebasehack.firebaseio.com/"+self.ref.authData.uid, forKey: "userData")

                    NSUserDefaults.standardUserDefaults().setValue(self.emailField.text, forKey: "email")

                    self.MyKeychainWrapper.mySetObject(self.passwordField.text, forKey:kSecValueData)
                    self.MyKeychainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    // go to homepage
                    self.performSegueWithIdentifier("gohome", sender: sender)

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
        self.ref.createUser(emailField.text, password: passwordField.text,
            withValueCompletionBlock: { error, result in
                
                if error != nil {
                    // There was an error creating the account
                    let alertView = UIAlertController(title: "Error!",
                        message: "Please try again" as String, preferredStyle:.Alert)
                    let newAccountAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                    alertView.addAction(newAccountAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                    self.navigationController?.popViewControllerAnimated(true)
                    
                } else {
                    // account created
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                    NSUserDefaults.standardUserDefaults().setValue(uid, forKey: "uid")
                    
                    
                    // Magnet login
                    let credential = NSURLCredential(user: self.emailField.text!, password: self.passwordField.text!, persistence: .None)
                    
                    let user = MMXUser()
                    
                    // temporarily uses email as username
                    user.displayName = uid
                    user.registerWithCredential(credential,
                        success: {
                            // registrration success
                        },
                        failure: { (error) -> Void in
                            // error.code == 409 if the user already exists
                            // or other error
                    })

                    
                    // Firebase login
                    self.ref.authUser(self.emailField.text, password:self.passwordField.text) {
                        error, authData in
                        if error != nil {
                            // Something went wrong. :(
                        } else {
                            // Authentication just completed successfully :)
                            
                            // The logged in user's unique identifier
                            print(authData.uid)
                            
                    
                            
                            // Create a child path with a key set to the uid underneath the "users" node
                            // This creates a URL path like the following:
                            //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
                            self.ref.childByAppendingPath("users")
                                .childByAppendingPath(self.ref.authData.uid).childByAppendingPath("email").setValue(self.emailField.text)
                        }
                    }
                    
                    // save user email in phone
                    NSUserDefaults.standardUserDefaults().setValue(self.emailField.text, forKey: "email")
                    
                    //save password in keychain
                    self.MyKeychainWrapper.mySetObject(self.passwordField.text, forKey:kSecValueData)
                    self.MyKeychainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().synchronize()

                    // alert user of successful
                    let alertView = UIAlertController(title: "Account Created!",
                        message: "" as String, preferredStyle:.Alert)
                    let newAccountAction = UIAlertAction(title: "Awesome!", style: .Default, handler: { (action: UIAlertAction!) in
                        self.performSegueWithIdentifier("moreInfo", sender: sender)
                    })
                    alertView.addAction(newAccountAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Indicate that you are ready to receive messages now!
        MMX.start()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didReceiveMessage:",
            name: MMXDidReceiveMessageNotification,
            object: nil)
    }
    
    /*
    func didReceiveMessage(notification: NSNotification) {
        let userInfo : [NSObject : AnyObject] = notification.userInfo!
        let message = userInfo[MMXMessageKey] as! MMXMessage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    } */

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
