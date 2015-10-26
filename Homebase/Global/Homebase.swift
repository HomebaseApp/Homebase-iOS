//
//  Homebase.swift
//  Homebase
//
//  Created by Justin Oroz on 10/23/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Parse

class Homebase : PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var location: PFGeoPoint
    @NSManaged var name: String
    
    @NSManaged var owner: HomebaseUser
    @NSManaged private(set) var admins: PFRelation
    @NSManaged private(set) var users: PFRelation


    
    static func parseClassName() -> String {
        return "Homebase"
    }
}