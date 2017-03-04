//
//  CKAssetExtension.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import CloudKit
import UIKit

extension CKAsset {
	convenience init?(from image:UIImage) {
		guard let imageData = UIImagePNGRepresentation(image) else { return nil }
		let filename = ProcessInfo.processInfo.globallyUniqueString
		let url = NSURL.fileURL(withPath: NSTemporaryDirectory()).appendingPathComponent(filename)
		guard ((try? imageData.write(to: url, options: Data.WritingOptions.atomicWrite)) != nil) else { return nil }
		self.init(fileURL: url)
		guard ((try? FileManager.default.removeItem(at: url)) != nil) else { return }

	}
}
