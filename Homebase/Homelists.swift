//
//  Homelist.swift
//  Homebase
//
//  Created by Justin Oroz on 10/28/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import Parse

class Homelist: PFObject, PFSubclassing {
    
    
    static func parseClassName() -> String {
        return "Homelist"
    }
}
