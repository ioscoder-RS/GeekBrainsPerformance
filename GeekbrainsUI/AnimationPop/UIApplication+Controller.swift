//
//  UIApplication+Controller.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 26/12/2019.
//  Copyright © 2019 raskin-sa. All rights reserved.
//

import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?{
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        } // if let navigationController = controller as?
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }//if let tabController = controller as?
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
} //extension UIApplication
