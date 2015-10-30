//
//  AppDelegate.swift
//  Homebase
//
//  Created by Justin Oroz on 10/9/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.parseInit()
        self.registerPush(application, launchOptions: launchOptions)
        self.checkLoginStatus()
        return true
    }
    
    func parseInit(){
        print("Parse API Version: " + PARSE_VERSION)
        
        // intialize subclasses
        registerParseSubclasses()
        
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("gpJJ7dVxBELxs7tEQBKEYJe6yJIVcAYUGX6SwIy8",
            clientKey: "sHNC2SaMqAtQWJHxT166Z0RHOtBEDaghO41TFEKO")
        
        // Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(nil)
    }
    
    func registerParseSubclasses(){
        Comment.registerSubclass()
        Bulletin.registerSubclass()
        RotationList.registerSubclass()
        Homebase.registerSubclass()
        HomebaseUser.registerSubclass()
    }
    
    func checkLoginStatus(){
        
        if let currentUser = user() {
            // Do stuff with the user
            
            currentUser.homebase!.fetchIfNeededInBackgroundWithBlock({
                // checks if homebase points to a valid object
                (result, error) -> Void in
                
                if error == nil {
                    // user has selected homebase
                    self.showViewController("mainpage")
                    print("User Logged In Successfully and has selected a Homebase")
                } else {
                    // no homebase selected
                    currentUser.homebase = nil // clears an invalid pointer
                    self.showViewController("selectHomebase")
                    print("User Logged In Successfully but has not selected a Homebase")
                }
            })

        } else {
            // Show the signup or login screen
            showViewController("loginNavigator")
            print("User is not logged in")
        }
    }
    
    // Parse Push notifcations
    func registerPush(application: UIApplication, launchOptions: [NSObject: AnyObject]?){
        // Register for Push Notitications        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    // end Parse Push notification code
    
    
    func showViewController(name: String){
        let initialViewController = self.storyboard.instantiateViewControllerWithIdentifier(name)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
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

