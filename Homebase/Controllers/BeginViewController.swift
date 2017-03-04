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

enum BeginButtonTask {
	case begin
	case retry
	case settingsCloud
	case settingsRestrictions
}

class BeginViewController: UIViewController {
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }

	@IBOutlet weak var beginButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var logo: UIImageView!

	var user: User?
	var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

		buttonConfig(task: nil)

		CKContainer.default().accountStatus(completionHandler: self.checkAccountStatus)

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func checkAccountStatus(accountStatus: CKAccountStatus, error: Error?) {
		switch accountStatus {
		case .available:
			print("iCloud Available")
			CKContainer.default().fetchUserRecordID(completionHandler: self.fetchUserRecord)

		case .noAccount:
			print("No iCloud account")
			self.buttonConfig(task: .settingsCloud)

			displayAlert(titled: "iCloud Account Required",
			             message: "Please log into iCloud",
			             actionTitle: "Settings",
			             action: { (action) in
							UIApplication.shared.open(URL(string: "App-Prefs:root=CASTLE")!)
			}, cancel: nil)

			DispatchQueue.main.async {
				self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
					CKContainer.default().accountStatus(completionHandler: { (status, error) in

						guard error == nil else {
							return
						}
						if status != .noAccount {
							DispatchQueue.main.async {
								CKContainer.default().accountStatus(completionHandler: self.checkAccountStatus)
								self.timer.invalidate()
							}
						}
					})
				})
			}

		case .restricted:
			print("iCloud restricted")
			buttonConfig(task: .settingsRestrictions)

			DispatchQueue.main.async {
				self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
					CKContainer.default().accountStatus(completionHandler: { (status, error) in

						guard error == nil else {
							return
						}

						if status != .restricted {
							DispatchQueue.main.async {
								CKContainer.default().accountStatus(completionHandler: self.checkAccountStatus)
								self.timer.invalidate()
							}
						}
					})
				})
			}

			displayAlert(titled: "iCloud Access Denied",
			             message: "Please modify restrictions",
			             actionTitle: "Settings",
			             action: { (action) in
							UIApplication.shared.open(URL(string: "App-Prefs:root=General")!)
			}, cancel: nil)

		case .couldNotDetermine:
			print("Unable to determine iCloud status: \(error.debugDescription)")
			buttonConfig(task: .retry)
			displayAlert(titled: "iCloud Error",
			             message: error?.localizedDescription,
			             actionTitle: "Retry",
			             action: { (action) in
							CKContainer.default().accountStatus(completionHandler: self.checkAccountStatus)
			}, cancel: nil)
		}
	}

	func fetchUserRecord(recordID: CKRecordID?, error: Error?) {

		guard error == nil else {
			buttonConfig(task: .retry)
			displayAlert(titled: "Login Failed",
			             message: error!.localizedDescription,
			             actionTitle: "Retry",
			             action: { (action) in
				CKContainer.default().accountStatus(completionHandler: self.checkAccountStatus)
			})
			return
		}

		guard recordID != nil else {
			buttonConfig(task: .retry)
			displayAlert(titled: "Login Failed", message: "Empty User Record ID", actionTitle: "Retry", action: { (action) in
				CKContainer.default().accountStatus(completionHandler: self.checkAccountStatus)
			})
			return
		}

		User.fetch(withRecordID: recordID!) { (user, error) in

			guard error == nil else {
				self.buttonConfig(task: .retry)
				self.displayAlert(titled: "Login Failed",
				                  message: error!.localizedDescription,
				                  actionTitle: "Retry",
				                  action: { (action) in
					CKContainer.default().accountStatus(completionHandler: self.checkAccountStatus)
				})
				return
			}

			self.user = user

			guard let user = user else {
				self.buttonConfig(task: .retry)
				self.displayAlert(titled: "Login Failed",
				                  message: "User Record Fetch Returned Empty",
				                  actionTitle: "Retry",
				                  action: { (action) in
					CKContainer.default().accountStatus(completionHandler: self.checkAccountStatus)
				})
				return
			}

			guard user.base != nil else {
				print("User not connected to a Homebase")
				self.buttonConfig(task: .begin)
				return
			}

			// user is connected to a base
			DispatchQueue.main.async {
				self.performSegue(withIdentifier: "login", sender: user)
			}
		}
	}

	func displayAlert(titled title: String?, message: String?, actionTitle: String,
	                  action: ((UIAlertAction) -> Void)? = nil,
	                  cancel: ((UIAlertAction) -> Void)? = nil) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: action))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancel))

		DispatchQueue.main.async {
			self.present(alert, animated: true, completion: nil)
		}
	}

	func buttonConfig(task: BeginButtonTask?) {
		DispatchQueue.main.async {
			switch task {
			case .begin?:
				self.beginButton.isHidden = false
				self.activityIndicator.stopAnimating()
				self.beginButton.setTitle("Begin", for: .normal)
				self.beginButton.restorationIdentifier = "begin"
			case .retry?:
				self.beginButton.isHidden = false
				self.activityIndicator.stopAnimating()
				self.beginButton.setTitle("Retry", for: .normal)
				self.beginButton.restorationIdentifier = "retry"
			case .settingsCloud?:
				self.beginButton.isHidden = false
				self.activityIndicator.stopAnimating()
				self.beginButton.setTitle("Settings", for: .normal)
				self.beginButton.restorationIdentifier = "icloud"
			case .settingsRestrictions?:
				self.beginButton.isHidden = false
				self.activityIndicator.stopAnimating()
				self.beginButton.setTitle("Settings", for: .normal)
				self.beginButton.restorationIdentifier = "restrictions"
			default:
				self.beginButton.isHidden = true
				self.activityIndicator.startAnimating()
			}
		}
	}

	@IBAction func buttonPressed(_ sender: UIButton) {
		switch sender.restorationIdentifier {
		case "begin"?:
			self.performSegue(withIdentifier: "userInfo", sender: self.user)
		case "icloud"?:
			UIApplication.shared.open(URL(string: "App-Prefs:root=CASTLE")!)
		case "restrictions"?:
			UIApplication.shared.open(URL(string: "App-Prefs:root=General&path=AUTOLOCK")!)
		case "retry"?:
			CKContainer.default().accountStatus(completionHandler: self.checkAccountStatus)
			buttonConfig(task: nil)
		default:
			return
		}
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
