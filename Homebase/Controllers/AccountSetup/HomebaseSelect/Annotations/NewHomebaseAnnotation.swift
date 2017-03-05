//
//  newHomebaseAnnotationView.swift
//  Homebase
//
//  Created by Justin Oroz on 3/4/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import UIKit
import Mapbox
import MapboxGeocoder

class NewHomebaseAnnotation: NSObject, MGLAnnotation {

	var coordinate: CLLocationCoordinate2D

	// saves the coordinates of the last retrieved address
	private var placemarkCoordinates: CLLocationCoordinate2D?

	var placemark: GeocodedPlacemark?
	var title: String? {

		if placemarkNeedsUpdating() {
			updatePlacemark(completion: nil)
			// TODO: Implement custom callout and show activity indicator
			return nil

		}

		guard let address = self.address else {
			return "\(coordinate.longitude), \(coordinate.latitude)"
		}

		return address.street
	}

	var address: CNPostalAddress? {
		guard let placemark = self.placemark else { return nil }
		return placemark.postalAddress
	}

	init(coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
	}

	convenience init(placemark: GeocodedPlacemark) {
		self.init(coordinate: placemark.location.coordinate)
		self.placemark = placemark
	}

	func updatePlacemark(completion: ((GeocodedPlacemark?, Error?) -> Void)?) {
		let geocoder = Geocoder.shared

		let options = ReverseGeocodeOptions(coordinate: coordinate)

		let saveCoords = coordinate

		let _ = geocoder.geocode(options) { (placemarks, _ /* attribution */, error) in

			guard error == nil,
				let placemark = placemarks?.first else {
					self.placemark = nil
					completion?(nil, error)
					return
			}

			self.placemarkCoordinates = saveCoords
			self.placemark = placemark
			completion?(self.placemark, error)
		}

	}

	func placemarkNeedsUpdating() -> Bool {
		guard let placemarkCoordinates = self.placemarkCoordinates else {
			return true
		}

		if coordinate == placemarkCoordinates {
			return false
		} else {
			return true
		}
	}

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
