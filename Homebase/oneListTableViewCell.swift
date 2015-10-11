//
//  oneListTableViewCell.swift
//  Homebase
//
//  Created by Michael A. Gonzalez on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit

class oneListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var item: UITextField!
    
}
