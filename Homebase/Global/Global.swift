//
//  Global.swift
//  Homebase
//
//  Created by Justin Oroz on 10/22/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Foundation
import Parse


func user() -> HomebaseUser? {
    return HomebaseUser.currentUser()
}

extension Homebase {
    static func user() -> HomebaseUser? {
        return HomebaseUser.currentUser()
    }
}

var colorTheme = UIColor()