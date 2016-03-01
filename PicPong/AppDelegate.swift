//
//  AppDelegate.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-21.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Initialize Parse.
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Photo.registerSubclass()
        Pong.registerSubclass()
        Player.registerSubclass()
        
        Parse.setApplicationId(Constant.applicationID.rawValue,
            clientKey: Constant.clientID.rawValue)
        
        let tabBarController = window!.rootViewController as! UITabBarController
        let tabBar = tabBarController.tabBar as UITabBar
        
        let tabBarItem1 = tabBar.items![0] as UITabBarItem
        let tabBarItem2 = tabBar.items![1] as UITabBarItem
        
        tabBarItem1.selectedImage = UIImage(named: "pong512")
        tabBarItem2.selectedImage = UIImage(named: "pong515")
        
        return true
    }

}

