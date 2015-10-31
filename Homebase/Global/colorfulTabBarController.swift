//
//  colorfulTabBarController.swift
//  Homebase
//
//  Created by Justin Oroz on 10/31/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit
import ChameleonFramework

class colorfulTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = mainThemeColor
        self.tabBar.barTintColor = UIColor.whiteColor()
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = mainThemeColor.CGColor
    }
    
}
