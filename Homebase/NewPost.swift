//
//  NewPost.swift
//  Homebase
//
//  Created by Justin Oroz on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class NewPost: UIViewController {

    // homebase specific broadcasts url
    let broadcasts = Firebase(url: (NSUserDefaults.standardUserDefaults().valueForKey("serverURL") as! String) + "/bases/" + (NSUserDefaults.standardUserDefaults().valueForKey("homebase") as! String) + "/broadcasts")
    
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
        print((NSUserDefaults.standardUserDefaults().valueForKey("serverURL") as! String) + "/" + (NSUserDefaults.standardUserDefaults().valueForKey("homebase") as! String) + "/broadcasts")
        
        
        let newPost = PostData(
            posterID: broadcasts.authData.uid,
            posterFullName: NSUserDefaults.standardUserDefaults().valueForKey("fullName") as! String,
            postText: postText.text
        )
        
        broadcasts.childByAutoId().setValue(newPost.fbReadable())

        
        self.navigationController?.popViewControllerAnimated(true)
        
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
