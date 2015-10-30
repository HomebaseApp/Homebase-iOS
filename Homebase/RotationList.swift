//
//  Homelist.swift
//  Homebase
//
//  Created by Justin Oroz on 10/28/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Parse

class RotationList: PFObject, PFSubclassing {
    
    @NSManaged private(set) var homebase: Homebase
    @NSManaged private var visibleBy: [HomebaseUser]
    @NSManaged private(set) var visibleToHomebase: Bool
    
    @NSManaged private(set) var name: String
    @NSManaged private(set) var listDescription: String
    
    
    
    func addUserToRoation(user: HomebaseUser){
        // add user to rotation
    }
    
    
    static func parseClassName() -> String {
        return "RotationList"
    }
}
