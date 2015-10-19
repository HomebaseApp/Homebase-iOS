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
    
    let userData = Firebase(url: NSUserDefaults.standardUserDefaults().valueForKeyPath("url/userData") as! String)

    let homebases = Firebase(url: NSUserDefaults.standardUserDefaults().valueForKeyPath("url/bases") as! String)
    

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
        if(homebaseField.text == ""
            || homebaseField.text?.containsString(".") == true
            || homebaseField.text?.containsString("#") == true
            || homebaseField.text?.containsString("$") == true
            || homebaseField.text?.containsString("[") == true
            || homebaseField.text?.containsString("]") == true
            ) {
            let alertView = UIAlertController(title: "Error",
                message: "Invalid Entry" as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        
        
        //save homebase name in info on firebase
        userData.childByAppendingPath("homebase").setValue(homebaseField.text)
        
        
        //save the homebase info to local storage
        modifyLocalHomebasedata()
        
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
    
    private func modifyLocalHomebasedata(){
        
        // grab the dictionary
        var localUserData = NSUserDefaults.standardUserDefaults().valueForKey("userData") as! Dictionary<String,String>
        
        //modify the dictionary
        localUserData["homebase"] = homebaseField.text
        
        //put it back
        NSUserDefaults.standardUserDefaults().setValue(localUserData, forKey: "userData")
        
        NSUserDefaults.standardUserDefaults().setValue("https://homebasehack.firebaseio.com/bases/" + homebaseField.text!, forKeyPath: "url/homebase")
        NSUserDefaults.standardUserDefaults().synchronize()


        
    }

}
