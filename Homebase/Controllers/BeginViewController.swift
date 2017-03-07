//
//  BeginViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import UIKit
import FirebaseAuth
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
	@IBOutlet weak var goButton: UIButton!


	private var authHandle: FIRAuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(usernameTextChanged), name: .UITextFieldTextDidChange, object: self.usernameField)
		authHandle = FIRAuth.auth()?.addStateDidChangeListener(authStateListener)

    }

	private func signInAnonymously(){
		FIRAuth.auth()?.signInAnonymously() { (user, error) in
			if error == nil {
				print("Anonymous user created")
			} else {
				print("Error creating anonymous user: \(error!.localizedDescription)")
				self.signInAnonymously()
			}

		}
	}

	private func authStateListener(auth: FIRAuth, user: FIRUser?) { // called every time auth state changes
		guard user != nil else { // if user is not signed in
			// sign in anonymously
			FIRAuth.auth()?.signInAnonymously() { (user, error) in
				if error == nil {
					print("Anonymous user created")
				} else {
					self.signInAnonymously()
				}

			}
			// authStateListener will be called again due to state change
			return
		}

		guard !user!.isAnonymous else {
			DispatchQueue.main.async {
				self.activityIndicator.stopAnimating()
				self.userInputView.isHidden = false
			}
			print("User is logged in as anonymous")

			if let displayName = user?.displayName {
				self.welcomeLabel.text = "Welcome back"
				self.usernameField.text = displayName
				usernameTextChanged()
			}

			return
		}

		// user is logged in with an account
		self.performSegue(withIdentifier: "loggedIn", sender: nil)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if let handle = self.authHandle {
			FIRAuth.auth()?.removeStateDidChangeListener(handle)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	// MARK: - User Interface

	func displayAlert(titled title: String?, message: String?, type: CDAlertViewType? = .error, actionTitle: String? = nil,
	                  action: ((CDAlertViewAction) -> Void)? = nil,
	                  cancel: ((CDAlertViewAction) -> Void)? = nil) {

		let alert = CDAlertView(title: title, message: message, type: type)

		if actionTitle != nil {
			alert.add(action: CDAlertViewAction(title: actionTitle, handler: action))
			alert.add(action: CDAlertViewAction(title: "Cancel", handler: cancel))
		}

		DispatchQueue.main.async {
			alert.show()
		}
	}

	// MARK: - User Actions

	@IBAction func buttonPressed(_ sender: UIButton) {
		// TODO: Segue to login page
	}

	@IBAction func donePressed(_ sender: Any) {
		self.goButton.isHidden = true
		guard self.usernameField.text!.length >= 5  else {
			self.usernameField.shake()
			CDAlertView(title: "Too Short", message: "Username must be at least 5 characters", type: .warning).show({ (_) in
				self.usernameField.becomeFirstResponder()
			})
			return
		}

		let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
		changeRequest?.displayName = self.usernameField.text!
		changeRequest?.commitChanges { (error) in
			guard error == nil else {
				// TODO: Handle Errors by case
				self.displayAlert(titled: "Error", message: "Please try again")
				self.goButton.isHidden = false
				return
			}

			DispatchQueue.main.async {
				self.performSegue(withIdentifier: "userInfo", sender: nil)
			}
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(false)
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

extension BeginViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		return true
	}

	func usernameTextChanged() {
		if self.usernameField.text!.length >= 5 {
			self.goButton.isHidden = false
		} else {
			self.goButton.isHidden = true
		}
	}
}
