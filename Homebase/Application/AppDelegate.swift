//
//  AppDelegate.swift
//  Homebase
//
//  Created by Justin Oroz on 5/18/16.
//  Copyright © 2016 Justin Oroz. All rights reserved.
//

import UIKit
import DeviceKit
import ChameleonFramework
import Firebase
import GoogleSignIn

// swiftlint:disable line_length

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	var colorScheme = ColorSchemeOf(.analogous, color: HexColor("#8EC44A")!, isFlatScheme: false)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

		// Use Firebase library to configure APIs
		FIRApp.configure()

		GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
		GIDSignIn.sharedInstance().delegate = self

		//Chameleon.setGlobalThemeUsingPrimaryColor(colorScheme[0], with: .light)
		Chameleon.setGlobalThemeUsingPrimaryColor(colorScheme[0], withSecondaryColor: colorScheme[1], andContentStyle: .light)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

		let device = Device()

		if device.isPad {
			return .all
		} else if device.isPhone || device.isPod {
			return .allButUpsideDown
		} else {
			return .portrait
		}
	}

	@available(iOS 9.0, *)
	func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
  -> Bool {
	return GIDSignIn.sharedInstance().handle(url,
	                                         sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
	                                         annotation: [:])
	}

}

// MARK: - Google Sign in
extension AppDelegate: GIDSignInDelegate {
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
  // ...
  if let error = error {
	// ...
	return
  }

  guard let authentication = user.authentication else { return }
  let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                    accessToken: authentication.accessToken)
  // ...
	}

	func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
	            withError error: Error!) {
		// Perform any operations when the user disconnects from app here.
		// ...
	}
}
