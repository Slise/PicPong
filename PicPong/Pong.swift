//
//  Pong.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-22.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import Foundation
import Parse

class Pong : PFObject, PFSubclassing {
    
    @NSManaged var photos: [Photo]
    @NSManaged var nextPlayer: Player? 
    @NSManaged var originalPlayer: Player
    @NSManaged var finishedPong: Bool
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Pong"
    }
    
    func isFinished() -> Bool {
        return nextPlayer == originalPlayer
    }
    
}