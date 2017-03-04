//
//  BackgroundScrollView.swift
//  Homebase
//
//  Created by Justin Oroz on 3/3/17.
//  Copyright © 2017 Justin Oroz. All rights reserved.
//

import UIKit

class BackgroundScrollView: UIScrollView {

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.endEditing(false)
	}

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
