//
//  HomebaseSelectionViewController.swift
//  Homebase
//
//  Created by Justin Oroz on 3/4/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import UIKit
import Mapbox
import PermissionScope
import MapboxGeocoder
import GeoFire

class HomebaseSelectionViewController: UIViewController {

	@IBOutlet weak var map: MGLMapView!
	@IBOutlet weak var newHomebaseButton: UIButton!
	let permissions = PermissionScope(backgroundTapCancels: false)
	let geocoder = Geocoder.shared
	var userFound = false

    override func viewDidLoad() {
        super.viewDidLoad()

		map.delegate = self
		newHomebaseButton.backgroundColor = .clear
		requestPermissions()
		initialMapSetup()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func initialMapSetup() {
		map.attributionButton.backgroundColor = UIColor.clear
		map.attributionButton.tintColor = UIColor.lightGray
		map.minimumZoomLevel = 6

		// FIXME: Must provide Attribution elsewhere in app!
		// also provide option for telometry opt-out
		// https://www.mapbox.com/help/attribution/#mapbox-gl-js
		map.attributionButton.isHidden = true
	}

	func requestPermissions() {
		permissions.addPermission(LocationWhileInUsePermission(), message: "We use this to show\nnearby Homebases")
		permissions.headerLabel.text = "Almost There!"
		permissions.bodyLabel.text = "We need your location"
		permissions.closeButton.isHidden = true

		permissions.show({ (_, _) in
			self.map.showsUserLocation = true
		}, cancelled: nil)
	}

	@IBOutlet weak var newHomebaseActivityIndicator: UIActivityIndicatorView!

	// Executes UI actions which should occur while geocoding to place a new Homebase annotation.
	func placingNewHomebase(_ ans: Bool) {
		if ans {
			newHomebaseActivityIndicator.startAnimating()
			newHomebaseButton.isHidden = true
		} else {
			newHomebaseActivityIndicator.stopAnimating()
			newHomebaseButton.isHidden = false
		}
	}

	var newHomebaseAnnotation: NewHomebaseAnnotation?

	func placeNewHomebase(atCoordinates coordinates: CLLocationCoordinate2D) {
		if self.newHomebaseAnnotation != nil {
			// remove old annotation if it exists
			self.map.removeAnnotation(self.newHomebaseAnnotation!)
		}
		self.newHomebaseAnnotation = NewHomebaseAnnotation(coordinate: coordinates)
		self.map.setCenter(coordinates, zoomLevel: 18, animated: true)
		self.map.addAnnotation(self.newHomebaseAnnotation!)
	}

	func placeNewHomebase(atPlacemark placemark: GeocodedPlacemark) {
		if self.newHomebaseAnnotation != nil {
			// remove old annotation if it exists
			self.map.removeAnnotation(self.newHomebaseAnnotation!)
		}
		self.newHomebaseAnnotation = NewHomebaseAnnotation(placemark: placemark)
		self.map.setCenter(placemark.location.coordinate, zoomLevel: 18, animated: true)
		self.map.addAnnotation(self.newHomebaseAnnotation!)
	}

	@IBAction func newHomebase(_ sender: Any) {
		guard let location = self.map.userLocation?.location else {
			return
		}

		placingNewHomebase(true)

		let options = ReverseGeocodeOptions(location: location)

		let _ = geocoder.geocode(options) { (placemarks, _ /* attribution */, error) in

			guard error == nil,
				let placemark = placemarks?.first,
				let address = placemark.postalAddress else {
				self.placeNewHomebase(atCoordinates: location.coordinate)
				self.placingNewHomebase(false)
				return
			}

			print("Placing Annotation at Geocoded Address: \(address.street)")
			self.placeNewHomebase(atPlacemark: placemark)
			self.placingNewHomebase(false)
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - MapboxView Delegate functions
extension HomebaseSelectionViewController: MGLMapViewDelegate {

	func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
		if !userFound {

			//self.map.setCenter(userLocation!.coordinate, zoomLevel: 18, animated: true)
			self.map.setUserTrackingMode(.follow, animated: false)
			self.map.setZoomLevel(18, animated: true)
			self.newHomebaseButton.isHidden = false
			userFound = true
		}
	}

	func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
		// TODO: fetch annotations
	}

	func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
		if annotation is MGLUserLocation {
			return nil
		} else if annotation is NewHomebaseAnnotation {
			var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "new") as? NewHomebaseAnnotationView

			if annotationView == nil {
				annotationView = NewHomebaseAnnotationView(reuseIdentifier: "new")
			}

			annotationView!.isDraggable = true
			
			annotationView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

			return annotationView
		} else {
			var annotation =  mapView.dequeueReusableAnnotationView(withIdentifier: "homebase")
			if annotation == nil {
				// TODO: Create custom annotation view for homebases, or move to image
				annotation = MGLAnnotationView(reuseIdentifier: "homebase")
			}
			annotation?.isDraggable = true
			return annotation
		}
	}

	func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
		return true
	}

}
