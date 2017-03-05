//
//  UIImageExtension.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import UIKit
import CloudKit

extension UIImage {
	convenience init?(from asset: CKAsset) {
		guard let imageData = try? Data(contentsOf: asset.fileURL) else { return nil }

		self.init(data: imageData)
	}
}
