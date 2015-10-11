//
//  NewPost.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase

class NewPost: UIViewController {

   // let ref = Firebase(url: NSUserDefaults.standardUserDefaults().valueForKey("homebaseURL") as! String + "/broadcasts")
    
    @IBOutlet weak var postText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func post(sender: AnyObject) {
        //let time = FirebaseServerValue.timestamp()
       // ref.childByAppendingPath(time.description).childByAppendingPath("fullName").valueForKey(NSUserDefaults.standardUserDefaults().valueForKey("fullName") as! String)
        //ref.childByAppendingPath(time.description).childByAppendingPath("text").valueForKey(NSUserDefaults.standardUserDefaults().valueForKey(postText.text) as! String)
        //ref.childByAppendingPath(time.description).childByAppendingPath("user").valueForKey(NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String)
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
