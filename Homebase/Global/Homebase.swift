//
//  Homebase.swift
//  Homebase
//
//  Created by Justin Oroz on 10/23/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Parse

class Homebase : PFObject, PFSubclassing {
    
    @NSManaged private(set) var location: PFGeoPoint
    @NSManaged private(set) var name: String
    
    @NSManaged private(set) var owner: HomebaseUser
    
    @NSManaged private(set) var admins: PFRelation
    @NSManaged private(set) var users: PFRelation
    override init() {
        super.init()
    }

    init(name: String, location: PFGeoPoint, owner: HomebaseUser){
        super.init()
        
        self.owner = owner
        admins.addObject(owner)
        users.addObject(owner)
        
        self.name = name
        self.location = location
        }

    
    static func parseClassName() -> String {
        return "Homebase"
    }
}