//
//  UIViewController+Extension.swift
//  ImageGallery
//
//  Created by Sergio Aragonés on 21/10/2020.
//  Copyright (c) 2020 Sergio Aragonés. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func getCurrentNavigationController() -> UINavigationController? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let window = appDelegate.window
        if let rootController = window?.rootViewController {
            
            if let navigationController = rootController.presentedViewController as? UINavigationController {
                return navigationController
            } else if let rootController = rootController as? UINavigationController {
                return rootController
            } else if let rootController = rootController as? UITabBarController,
                let controller = rootController.selectedViewController as? UINavigationController {
                return controller
            }
        }
        
        return nil
    }
    
    static func getCurrentViewController() -> UIViewController? {
        
        if let nav = UIViewController.getCurrentNavigationController() {
            return nav.viewControllers.last
        } else if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let window = appDelegate.window
            return window?.rootViewController
        }
        
        return nil
    }
    
    static func getCurrentWindow() -> UIWindow? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.window
    }
    
    func fullRemoveFromParent() {
        
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
