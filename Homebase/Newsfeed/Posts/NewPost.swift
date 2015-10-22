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

class NewComment: UIViewController, UITextViewDelegate {
    
    let userData = NSUserDefaults.standardUserDefaults().valueForKey("userData") as! Dictionary<String, String>
    
    var thePostInfo = PostData()
    
    @IBOutlet weak var postText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotifications()
        setupTextView()
        postText.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func comment(sender: AnyObject) {
        
        let newComment = PostData(
            posterID: server.ref().authData.uid,
            posterFullName: userData["fullName"]!,
            postText: postText.text
        )
        
        server.broadcasts().childByAppendingPath(thePostInfo.broadcastID + "/comments").childByAutoId().setValue(newComment.fbReadable())

        
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
    
    //textView delegate functions & Properties
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        // if the text color is gray, clear it, set black
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        // if text is empty after editing, replace with placeholderasd
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGrayColor()
        }
    }

    
    func setupTextView() {
        postText.textContainerInset.left = 8.0
        postText.textContainerInset.right = 8.0
        postText.textColor = UIColor.lightGrayColor()
        postText.directionalLockEnabled = true
    }
    
    //code for textfield resizing on keyboard popup
    // http://bit.ly/1W1RZEO
    func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardDidShowNotification, object: nil)
    }
    
    func keyboardWasShown(aNotification:NSNotification) {
        let info = aNotification.userInfo
        let infoNSValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let kbSize = infoNSValue.CGRectValue().size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 4, 0.0)
        postText.contentInset = contentInsets
        postText.scrollIndicatorInsets = contentInsets
    }
    
}
