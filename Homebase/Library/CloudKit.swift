//
//  CloudKit.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import CloudKit

enum CloudStatusError: Error {
	case restricted
	case noAccount
	case undetermined(error:Error)
}

class CKRecordShell {
	public let record: CKRecord

	public var created: Date? {
		get {
			return record.creationDate
		}
	}

	public var id: CKRecordID {
		get {
			return record.recordID
		}
	}

	init?(record: CKRecord?) {
		if record != nil {
			self.record = record!
		} else {
			return nil
		}

	}

}

protocol CKRecordShellSync {
	static var database: CKDatabase {get}
	func save(complete: @escaping (CKRecord?, Error?) -> Void)
	func delete(complete: @escaping (CKRecordID?, Error?) -> Void)
}
