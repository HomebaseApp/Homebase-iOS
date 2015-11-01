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
    @NSManaged private(set) var userFullName: String
    @NSManaged private(set) var commentCount: Int
    

    
    override init(){
        super.init()
    }
    
    init(text: String){
        super.init()
        
        self.user = Homebase.user()!
        self.homebase = self.user.homebase!
        self.userFullName = self.user.fullName
        self.text = text
        self.commentCount = 0
        
    }
    
    func addComment(){
        commentCount++
    }
    
    static func parseClassName() -> String {
        return "Bulletin"
    }
}