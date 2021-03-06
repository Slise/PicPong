//
//  Player.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-25.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import Foundation
import Parse

class Player: PFUser {
    
    @NSManaged var country: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}