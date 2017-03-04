//
//  CommentRecord.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import CloudKit

class Comment: CKRecordShell, CKRecordShellSync {
	internal static var database: CKDatabase = CKContainer.default().publicCloudDatabase

	override init?(record: CKRecord?) {
		super.init(record: record)
	}

	convenience init!() {
		self.init(record: CKRecord(recordType: "Comment"))
	}

	public func save(complete: @escaping (CKRecord?, Error?) -> Void) {
		Comment.database.save(self.record, completionHandler: complete)
	}

	// Ensure deletion of this object after deletion of record
	public func delete(complete: @escaping (CKRecordID?, Error?) -> Void) {
		Comment.database.delete(withRecordID: id, completionHandler: complete)
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

	public var text: String? {
		get {
			return record["text"] as? String
		}
		set {
			record["text"] = newValue as CKRecordValue?
			wasModified()
		}
	}

	public var post: CKReference? {
		get {
			return record["post"] as? CKReference
		}
		set {
			record["post"] = newValue as CKRecordValue?
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

}

extension Comment { // Static fetch functions
	static func fetch(withRecordID recordID: CKRecordID, completionHandler: @escaping (Comment?, Error?) -> Void) {
		database.fetch(withRecordID: recordID) {(record, error) in
			completionHandler(Comment(record: record), error)
		}
	}

	static func query(predicate: NSPredicate, completionHandler: @escaping ([Comment]?, Error?) -> Void) {
		let query = CKQuery(recordType: "Comment", predicate: predicate)
		database.perform(query, inZoneWith: nil) { (records, error) in
			if let records = records {
				var comments: [Comment] = []
				for record in records {
					if let comment = Comment(record: record) {
						comments.append(comment)
					}
				}
				completionHandler(comments, error)
			} else {
				completionHandler(nil, error)
			}
		}
	}
}
