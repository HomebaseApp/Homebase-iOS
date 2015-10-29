//
//  Broadcasts.swift
//  Homebase
//
//  Created by Justin Oroz on 10/27/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Parse

class Comment : PFObject, PFSubclassing {

    @NSManaged private(set) var homebase: Homebase
    @NSManaged private(set) var user: HomebaseUser
    @NSManaged private(set) var bulletin: Bulletin
    @NSManaged private(set) var text: String
    
    override init(){
        super.init()
    }
    
    init(homebase: Homebase ,user: HomebaseUser, bulletin: Bulletin , text: String){
        super.init()
        
        self.homebase = homebase
        self.user = user
        self.text = text
        self.bulletin = bulletin
        
    }
    
    static func parseClassName() -> String {
        return "Comment"
    }
}