//
//  HomebaseAnnotation.swift
//  Homebase
//
//  Created by Justin Oroz on 10/23/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HomebaseAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let name:String
    let homebase: Homebase
    
    init(homebase: Homebase){
        self.coordinate = homebase.location.location().coordinate
        self.title = homebase.name
        self.name = homebase.name
        self.homebase = homebase
        super.init()
    }
    
    
}