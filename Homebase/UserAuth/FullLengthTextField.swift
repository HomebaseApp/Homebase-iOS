//
//  FullLengthTextField.swift
//  Homebase
//
//  Created by Justin Oroz on 10/30/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit

class FullLengthTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , 35, 0);
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , 35, 0);
    }

}
