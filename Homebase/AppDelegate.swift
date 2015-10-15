//
//  AppDelegate.swift
//  Homebase
//
//  Created by Justin Oroz on 10/9/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import MMX
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    let server = Firebase(url: "https://homebasehack.firebaseio.com")
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initialize Magnet Message
        MMX.setupWithConfiguration("default")

        //save firebase URL
        NSUserDefaults.standardUserDefaults().setValue("https://homebasehack.firebaseio.com", forKey: "serverURL")
        
        // checks Firebase login status
        server.observeAuthEventWithBlock({ authData in
            if authData != nil {
                // user authenticated
                // check if in a homebase
                
                //save most recent server data locally
                self.server.childByAppendingPath("users/"+self.server.authData.uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    if snapshot.exists() { //check if it has data
                        
                        if snapshot.hasChild("fullName") {
                            let fullName = snapshot.value.objectForKey("fullName")
                            NSUserDefaults.standardUserDefaults().setValue(fullName, forKey: "fullName")
                            print("Full Name Saved Locally")
                        }
                        if snapshot.hasChild("firstName") {
                            let firstName = snapshot.value.objectForKey("firstName")
                            NSUserDefaults.standardUserDefaults().setValue(firstName, forKey: "firstName")
                            print("First Name Saved Locally")
                        }
                        if snapshot.hasChild("lastName") {
                            let lastName = snapshot.value.objectForKey("lastName")
                            NSUserDefaults.standardUserDefaults().setValue(lastName, forKey: "lastName")
                            print("Last Name Saved Locally")
                        }
                        if snapshot.hasChild("homebase") {
                            let homebase = snapshot.value.objectForKey("homebase")
                            NSUserDefaults.standardUserDefaults().setValue(homebase, forKey: "homebase")
                            print("Joined Homebase: " + (NSUserDefaults.standardUserDefaults().valueForKey("homebase") as! String))
                            print("HomeBase Saved Locally")
                        }
                        if snapshot.hasChild("provider") {
                            let provider = snapshot.value.objectForKey("provider")
                            NSUserDefaults.standardUserDefaults().setValue(provider, forKey: "provider")
                            print("Authentication Provider Saved Locally")
                        }
                        
                        
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        
                    } // even if snapshot does not have data
                    
                    //select homebase if none chosen
                    if ( NSUserDefaults.standardUserDefaults().valueForKey("homebase") == nil){
                        let initialViewController = self.storyboard.instantiateViewControllerWithIdentifier("selectHomebase")
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    } else { //go to home page if homebase chosen
                        let initialViewController = self.storyboard.instantiateViewControllerWithIdentifier("mainpage")
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                    
                })
                

                
                print(authData)
            } else {
                // No user is signed in
                // go to login page
                let initialViewController = self.storyboard.instantiateViewControllerWithIdentifier("loginNavigator")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
                
                
            }
        })
        
        return true
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

