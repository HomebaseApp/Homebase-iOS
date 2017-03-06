//
//  newHomebaseAnnotationView.swift
//  Homebase
//
//  Created by Justin Oroz on 3/5/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import UIKit
import Mapbox

class NewHomebaseAnnotationView: MGLAnnotationView {

	var imageView: UIImageView = UIImageView()

	override func layoutSubviews() {
		super.layoutSubviews()

		self.imageView.image = #imageLiteral(resourceName: "Map New Annotation")
		self.imageView.frame = self.bounds
		self.imageView.contentMode = .scaleAspectFit
		self.addSubview(self.imageView)
		self.scalesWithViewingDistance = false
	}

	override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
		super.setDragState(dragState, animated: animated)
		switch dragState {
		case .starting:
			print("Starting", terminator: "")
		case .dragging:
			print(".", terminator: "")
		case .ending, .canceling:
			print("Ending")
			guard self.annotation != nil,
				let annotation = annotation as? NewHomebaseAnnotation else {
				return
			}

			if annotation.placemarkNeedsUpdating() {
				annotation.updatePlacemark(completion: { (placemark, error) in
					guard error == nil,
					let placemark = placemark else {
						return
					}

					
				})
			}
		case .none:
			return
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
