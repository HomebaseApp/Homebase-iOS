//
//  BeginViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import UIKit
import CloudKit
import ChameleonFramework
import CDAlertView

class BeginViewController: UIViewController {
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }

	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var logo: UIImageView!
	@IBOutlet weak var userInputView: UIView!
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var welcomeLabel: UILabel!

	var user: User?
	var username: String?
	var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



	// MARK: - User Interface

	func displayAlert(titled title: String?, message: String?, actionTitle: String,
	                  action: ((CDAlertViewAction) -> Void)? = nil,
	                  cancel: ((CDAlertViewAction) -> Void)? = nil) {

		let alert = CDAlertView(title: title, message: message, type: .error)
		alert.add(action: CDAlertViewAction(title: actionTitle, handler: action))
		alert.add(action: CDAlertViewAction(title: "Cancel", handler: cancel))

		DispatchQueue.main.async {
			alert.show()
		}
	}

	// MARK: - User Actions

	@IBAction func buttonPressed(_ sender: UIButton) {
		
	}

	@IBAction func donePressed(_ sender: UITextField) {
		guard sender.text!.length >= 5  else {
			self.usernameField.shake()
			CDAlertView(title: "Too Short", message: "Username must be at least 5 characters", type: .warning).show({ (_) in
				self.usernameField.becomeFirstResponder()
			})
			return
		}

		guard let user = user else {
			print("User record does not exist")
			return
		}

		user.username = sender.text!

		self.performSegue(withIdentifier: "userInfo", sender: user)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
