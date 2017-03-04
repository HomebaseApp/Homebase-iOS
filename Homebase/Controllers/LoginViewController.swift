//
//  LoginViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 8/6/16.
//  Copyright © 2016 Justin Oroz. All rights reserved.
//

import UIKit
import UITextField_Shake

class LoginViewController: UIViewController {

	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var signInButton: UIButton!
	@IBOutlet weak var signUpButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var userInputView: UIView!
	@IBOutlet weak var backgroundScrollVIew: BackgroundScrollView!

    override func viewDidLoad() {
		super.viewDidLoad()
        // Do any additional setup after loading the view.

		registerKeyboardNotifications()

    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		unregisterKeyboardNotifications()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(false)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Text Input functions
extension LoginViewController: UITextFieldDelegate {

	func registerKeyboardNotifications() {
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.keyboardWillShow),
		                                       name: .UIKeyboardWillShow,
		                                       object: nil)
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.keyboardWillHide),
		                                       name: .UIKeyboardWillHide,
		                                       object: nil)
	}

	func unregisterKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}

	func keyboardWillShow(notification: NSNotification) {
		print("Keyboard called")
		if let keyboardRect = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			let keyboardMinY = keyboardRect.minY
			let buttonMaxY = self.signInButton.convert(self.signInButton.frame, to: self.view).maxY
			let padding:CGFloat = 8.0
			let diff = keyboardMinY - buttonMaxY

			if (diff > 0) {
				self.backgroundScrollVIew.setContentOffset(CGPoint(x: 0, y: (diff+padding)), animated: true)
			}

		}
	}

	func keyboardWillHide(notification: NSNotification) {
		self.backgroundScrollVIew.setContentOffset(.zero, animated: true)
	}

	@IBAction func returnTapped(_ sender: UITextField) {

		switch sender.restorationIdentifier {
		case "emailField"?:
			self.passwordField.becomeFirstResponder()
		case "passwordField"?:
		// TODO: Submit form
			self.view.endEditing(false)
		default:
			print("Unknown textfield return")
		}
	}

}
