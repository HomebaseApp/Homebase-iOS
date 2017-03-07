//
//  UserRecord.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import CloudKit
import UIKit
import Firebase

enum UserRecordError: Error {
	case badRecordID(withError: Error?, details: String?)
	case nilUser(withError: Error?, details: String?)
}

class User: FirebaseRecord {

	internal let ref: FIRDatabaseReference!
	private var observerHandle: UInt = 0
	private var snapshot: [String: AnyObject]?
	private var dataInitialized = false

	init(uid: String, loadComplete: @escaping (_ user: User) -> Void) {
		ref = User.root.child("Users").child(uid)

		super.init()

		observerHandle = ref.observe(.childChanged, with: { (snapshot) in
			self.snapshot = snapshot.value as? [String : AnyObject] ?? [:]

			if !self.dataInitialized {
				loadComplete(self)
				self.dataInitialized = true
			}
		})
	}

	deinit {
		ref.removeObserver(withHandle: observerHandle)
	}

	var username: String? {
		get {
			return snapshot?["username"] as? String
		}
		set {
			ref.setValue(["username": newValue])
		}
	}
}
