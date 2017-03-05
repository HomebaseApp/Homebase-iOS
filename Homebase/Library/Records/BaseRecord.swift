//
//  Homebase.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import CloudKit
import UIKit

class Base: CKRecordShell, CKRecordShellSync {

	override init?(record: CKRecord?) {
		guard record?.recordType == "Base"  else {
			return nil
		}
		super.init(record: record)
	}

	convenience init!() {
		self.init(record: CKRecord(recordType: "Base"))
	}

	internal static let database = CKContainer.default().publicCloudDatabase

	public func save(complete: @escaping (CKRecord?, Error?) -> Void) {
		Base.database.save(self.record, completionHandler: complete)
	}

	// Ensure deletion of this object after deletion of record
	public func delete(complete: @escaping (CKRecordID?, Error?) -> Void) {
		Base.database.delete(withRecordID: id, completionHandler: complete)
	}

	// CKRecord Fields
	public var location: CLLocation? {
		get {
			return record["location"] as? CLLocation
		}
		set(newLoc) {
			record["location"] = newLoc
		}
	}

	public var members: [CKReference]? {
		get {
			return record["members"] as? [CKReference]
		}
		set(newArray) {
			record["members"] = newArray as CKRecordValue?
		}
	}

	public var owner: CKReference? {
		get {
			return record["owner"] as? CKReference
		}
		set(newArray) {
			record["owner"] = newArray as CKRecordValue?
		}
	}

	public var name: String? {
		get {
			return record["name"] as? String
		}
		set(newName) {
			record["name"] = newName as CKRecordValue?
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

	public var image: UIImage? {
		get {
			guard let asset = record["image"] as? CKAsset else { return nil }
			return UIImage(from: asset)
		}
		set {
			guard newValue != nil else {
				record["image"] = nil
				return
			}
			let asset = CKAsset(from: newValue!)
			record["image"] = asset as CKRecordValue?
		}
	}
}

extension Base { // Static fetch functions
	static func fetch(withRecordID recordID: CKRecordID, completionHandler: @escaping (Base?, Error?) -> Void) {
		database.fetch(withRecordID: recordID) {(record, error) in
			guard error == nil else {
				completionHandler(Base(record: record), error)
				return
			}

			guard let record = record else {
				completionHandler(nil, error)
				return
			}

			guard record.recordType == "Base" else {
				completionHandler(nil, RecordError.recordTypeMismatch)
				return
			}

			completionHandler(Base(record: record), error)		}
	}

	static func query(predicate: NSPredicate, completionHandler: @escaping ([Base]?, Error?) -> Void) {
		let query = CKQuery(recordType: "Base", predicate: predicate)
		database.perform(query, inZoneWith: nil) { (records, error) in
			if let records = records {
				var bases: [Base] = []
				for record in records {
					if let base = Base(record: record) {
						bases.append(base)
					}
				}
				completionHandler(bases, error)
			} else {
				completionHandler(nil, error)
			}
		}
	}
}
