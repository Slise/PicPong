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
    
    @NSManaged var pongImage: UIImage
    @NSManaged var images: [UIImage]
    @NSManaged var stepControl: Int
    @NSManaged var previousUserID: PFInstallation
    @NSManaged var originator: PFInstallation
    
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
}