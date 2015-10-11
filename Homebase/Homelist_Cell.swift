//
//  Homelist_Cell.swift
//  Homebase
//
//  Created by Michael A. Gonzalez on 10/10/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import UIKit

struct task{
    var title = "List title"
    var item = "Item name"
}

class Homelist_Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var NewList: UIButton!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    var tasks = [task](title, item)
//    
//    func addTask(title: String, item: String){
//        tasks.append(title, item)
//    }

    @IBOutlet weak var item: UITextField!
}
