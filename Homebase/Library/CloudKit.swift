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

enum RecordError: Error {
	case recordTypeMismatch
}

class CKRecordShell {
	public let record: CKRecord

	public var created: Date? {
		return record.creationDate
	}

	// swiftlint:disable:next variable_name
	public var id: CKRecordID {
			return record.recordID
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
