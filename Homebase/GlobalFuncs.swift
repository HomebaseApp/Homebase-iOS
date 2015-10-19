//
//  GlobalFuncs.swift
//  Homebase
//
//  Created by Justin Oroz on 10/19/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayBasicAlert(title:String, error:String, buttonText: String) {
        let alertView = UIAlertController(title: title,
            message: error, preferredStyle:.Alert)
        let okAction = UIAlertAction(title: buttonText, style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}


