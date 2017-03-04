//
//  PostRecord.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import CloudKit
import UIKit

class Post: CKRecordShell, CKRecordShellSync {
	internal static var database: CKDatabase = CKContainer.default().publicCloudDatabase

	override init?(record: CKRecord?) {
		super.init(record: record)
	}

	convenience init!() {
		self.init(record: CKRecord(recordType: "Post"))
	}

	public func save(complete: @escaping (CKRecord?, Error?) -> Void) {
		Post.database.save(self.record, completionHandler: complete)
	}

	// Ensure deletion of this object after deletion of record
	public func delete(complete: @escaping (CKRecordID?, Error?) -> Void) {
		Post.database.delete(withRecordID: id, completionHandler: complete)
	}

	public func wasModified() {
		self.modified = Date()
	}

	public func upVote() {
		if let votes=self.votes {
			self.votes = votes + 1
		} else {
			self.votes = 1
		}
	}

	public func downVote() {
		if let votes=self.votes {
			if votes > 0 {
				self.votes = votes - 1
			}
		} else {
			self.votes = 0
		}
	}

	// Record properties
	public var owner: CKReference? {
		get {
			return record["owner"] as? CKReference
		}
		set(new) {
			record["owner"] = new as CKRecordValue?
		}
	}

	public var base: CKReference? {
		get {
			return record["base"] as? CKReference
		}
		set(new) {
			record["base"] = new as CKRecordValue?
		}
	}

	public var text: String? {
		get {
			return record["text"] as? String
		}
		set(new) {
			record["text"] = new as CKRecordValue?
			wasModified()
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

	public private(set) var modified: Date? {
		get {
			return record["modified"] as? Date
		}
		set {
			record["modified"] = newValue as? CKRecordValue
		}
	}

	public internal(set) var votes: Int64? {
		get {
			return record["votes"] as? Int64
		}
		set {
			record["votes"] = newValue as? CKRecordValue
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

extension Post { // Static fetch functions
	static func fetch(withRecordID recordID: CKRecordID, completionHandler: @escaping (Post?, Error?) -> Void) {
		database.fetch(withRecordID: recordID) {(record, error) in
			completionHandler(Post(record: record), error)
		}
	}

	static func query(predicate: NSPredicate, completionHandler: @escaping ([Post]?, Error?) -> Void) {
		let query = CKQuery(recordType: "Post", predicate: predicate)
		database.perform(query, inZoneWith: nil) { (records, error) in
			if let records = records {
				var posts: [Post] = []
				for record in records {
					if let post = Post(record: record) {
						posts.append(post)
					}
				}
				completionHandler(posts, error)
			} else {
				completionHandler(nil, error)
			}
		}
	}
}
