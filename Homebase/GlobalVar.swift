//
//  GlobalVar.swift
//  Homebase
//
//  Created by Justin Oroz on 10/19/15.
//  Copyright © 2015 HomeBase. All rights reserved.
//

import Foundation
import Firebase

struct urls { //Firebases objects of all frequently used URLS

    private let Server = "https://homebasehack.firebaseio.com"


    func ref() -> Firebase{ return Firebase(url: Server) }
    func bases() -> Firebase{ return ref().childByAppendingPath("bases") }
    func chats() -> Firebase{ return ref().childByAppendingPath("chats") }
    func users() -> Firebase{ return ref().childByAppendingPath("users") }
    
    func homebase() -> Firebase{
        let userData = NSUserDefaults.standardUserDefaults().valueForKey("userData") as! Dictionary<String, String>
        return bases().childByAppendingPath(userData["homebase"]!)
    }
    
    func broadcasts() -> Firebase{
        return homebase().childByAppendingPath("broadcasts")
    }
    
    func userData() -> Firebase{
        return users().childByAppendingPath(ref().authData.uid)
    }
}

let server = urls()