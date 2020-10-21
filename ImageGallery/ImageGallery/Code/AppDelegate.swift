//
//  AppDelegate.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 21/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        //TODO load root view controller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

}

