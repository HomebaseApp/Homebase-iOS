//
//  UserRecord.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import CloudKit
import UIKit

enum UserRecordError: Error {
	case badRecordID(withError: Error?, details: String?)
	case nilUser(withError: Error?, details: String?)
}

class User: CKRecordShell, CKRecordShellSync {
	internal static var database: CKDatabase = CKContainer.default().publicCloudDatabase

	override init?(record: CKRecord?) {
		guard record?.recordType == "Users"  else {
			return nil
		}
		super.init(record: record)
	}

	convenience init!() {
		self.init(record: CKRecord(recordType: "Users"))
	}

	public func save(complete: @escaping (CKRecord?, Error?) -> Void) {
		User.database.save(self.record, completionHandler: complete)
	}

	// Ensure deletion of this object after deletion of record
	public func delete(complete: @escaping (CKRecordID?, Error?) -> Void) {
		User.database.delete(withRecordID: id, completionHandler: complete)
	}

	// Record properties
	public var base: CKReference? {
		get {
			return record["base"] as? CKReference
		}
		set(new) {
			record["base"] = new as CKRecordValue?
		}
	}

	public var posts: [CKReference]? {
		get {
			return record["posts"] as? [CKReference]
		}
		set(newArray) {
			record["posts"] = newArray as CKRecordValue?
		}
	}

	public var comments: [CKReference]? {
		get {
			return record["comments"] as? [CKReference]
		}
		set {
			record["comments"] = newValue as CKRecordValue?
		}
	}

	public var profilePic: UIImage? {
		get {
			guard let asset = record["profilePic"] as? CKAsset else { return nil }
			return UIImage(from: asset)
		}
		set {
			guard newValue != nil else {
				record["profilePic"] = nil
				return
			}
			let asset = CKAsset(from: newValue!)
			record["profilePic"] = asset as CKRecordValue?
		}
	}

	public var username: String? {
		get {
			return record["username"] as? String
		}
		set {
			record["username"] = newValue as CKRecordValue?
		}
	}

	public var lastName: String? {
		get {
			return record["lastName"] as? String
		}
		set {
			record["lastName"] = newValue as CKRecordValue?
		}
	}

	public var firstName: String? {
		get {
			return record["firstName"] as? String
		}
		set {
			record["firstName"] = newValue as CKRecordValue?
		}
	}
}

extension User { // Static fetch functions
	static func fetch(withRecordID recordID: CKRecordID, completionHandler: @escaping (User?, Error?) -> Void) {
		database.fetch(withRecordID: recordID) {(record, error) in

			guard error == nil else {
				completionHandler(User(record: record), error)
				return
			}

			guard let record = record else {
				completionHandler(nil, error)
				return
			}

			print(record.recordType)

			guard record.recordType == "Users" else {
				completionHandler(nil, RecordError.recordTypeMismatch)
				return
			}

			completionHandler(User(record: record), error)

		}
	}

	static func query(predicate: NSPredicate, completionHandler: @escaping ([User]?, Error?) -> Void) {
		let query = CKQuery(recordType: "Users", predicate: predicate)
		database.perform(query, inZoneWith: nil) { (records, error) in
			if let records = records {
				var users: [User] = []
				for record in records {
					if let comment = User(record: record) {
						users.append(comment)
					}
				}
				completionHandler(users, error)
			} else {
				completionHandler(nil, error)
			}
		}
	}
}
