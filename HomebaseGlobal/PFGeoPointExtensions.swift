//
//  PFGeoPointExtensions.swift
//  Homebase
//
//  Created by Justin Oroz on 10/23/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Parse

extension PFGeoPoint {
    
    func location() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
}