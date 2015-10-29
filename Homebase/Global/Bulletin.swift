//
//  Broadcasts.swift
//  Homebase
//
//  Created by Justin Oroz on 10/27/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Parse

class Bulletin : PFObject, PFSubclassing {
    
    @NSManaged private(set) var homebase: Homebase
    @NSManaged private(set) var user: HomebaseUser
    @NSManaged private(set) var text: String
    
    override init(){
        super.init()
    }
    
    init(homebase: Homebase ,user: HomebaseUser, text: String){
        super.init()
        
        self.homebase = homebase
        self.user = user
        self.text = text
        
    }
    
    static func parseClassName() -> String {
        return "Bulletin"
    }
}