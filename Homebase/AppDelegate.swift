//
//  AppDelegate.swift
//  Homebase
//
//  Created by Justin Oroz on 10/9/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Firebase
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.parseInit()
        //self.parseTester()
        
        self.checkLoginStatus()
        
        //self.checkFirebaseLoginStatus()
        
        return true
    }
    
    func parseInit(){
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("gpJJ7dVxBELxs7tEQBKEYJe6yJIVcAYUGX6SwIy8",
            clientKey: "sHNC2SaMqAtQWJHxT166Z0RHOtBEDaghO41TFEKO")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(nil)
    }
    
    func parseTester(){
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
    }
    
    func checkLoginStatus(){
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            
            // do i need to update user info?
            
        } else {
            // Show the signup or login screen
            showViewController("loginNavigator")
        }
    }
    
    func showViewController(name: String){
        let initialViewController = self.storyboard.instantiateViewControllerWithIdentifier(name)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func checkFirebaseLoginStatus(){
        // checks Firebase login status
        server.ref().observeAuthEventWithBlock({ authData in
            if authData != nil {
                // user authenticated
                
                // create dictionary for userdata storage
                var localData: Dictionary<String, String> = Dictionary<String, String>()
                
                //save most recent server data locally
                server.userData().observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    if snapshot.exists() { //check if it has data
                        
                        // always has uid information if snapshot returns
                        localData["uid"] = server.userData().authData.uid
                        print("uid updated from Firebase")
                        
                        if snapshot.hasChild("email") {
                            let email = snapshot.value.objectForKey("email") as! String
                            localData["email"] = email
                            print("email updated from Firebase")
                        }
                        if snapshot.hasChild("fullName") {
                            let fullName = snapshot.value.objectForKey("fullName") as! String
                            localData["fullName"] = fullName
                            print("Full Name updated from Firebase")
                        }
                        if snapshot.hasChild("firstName") {
                            let firstName = snapshot.value.objectForKey("firstName") as! String
                            localData["firstName"] = firstName
                            print("First Name updated from Firebase")
                        }
                        if snapshot.hasChild("lastName") {
                            let lastName = snapshot.value.objectForKey("lastName") as! String
                            localData["lastName"] = lastName
                            print("Last Name updated from Firebase")
                        }
                        if snapshot.hasChild("homebase") {
                            let homebase = snapshot.value.objectForKey("homebase") as! String
                            localData["homebase"] = homebase
                            print("Joined Homebase: " + homebase)
                            print("HomeBase updated from Firebase")
                        }
                        if snapshot.hasChild("provider") {
                            let provider = snapshot.value.objectForKey("provider") as! String
                            localData["provider"] = provider
                            print("Authentication Provider updated from Firebase")
                        }
                        
                        //place the Dictionary in storage
                        NSUserDefaults.standardUserDefaults().setValue(localData, forKey: "userData")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                    } // even if snapshot does not have data
                    
                    //select homebase if none chosen
                    if ( localData["homebase"] == nil){
                        let initialViewController = self.storyboard.instantiateViewControllerWithIdentifier("selectHomebase")
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    } else { //go to home page if homebase chosen
                        let initialViewController = self.storyboard.instantiateViewControllerWithIdentifier("mainpage")
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                    
                })
            } else {
                // No user is signed in
                // go to login page
                let initialViewController = self.storyboard.instantiateViewControllerWithIdentifier("loginNavigator")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
            }
        })
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

