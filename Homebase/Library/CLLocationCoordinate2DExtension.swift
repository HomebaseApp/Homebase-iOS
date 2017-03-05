//
//  CLLocationCoordinate2DExtension.swift
//  Homebase
//
//  Created by Justin Oroz on 3/5/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
	static func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
		if left.latitude == right.latitude && left.longitude == right.longitude {
			return true
		} else {
			return false
		}
	}
}
