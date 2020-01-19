//
//  Extension+UIResponder.swift
//  dvach
//
//  Created by Ruslan Timchenko on 10/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension TimeInterval {
    static let animationDuration = 0.3
}

extension UIResponder {
    func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    
    func hideStatusBar(_ hide: Bool, animation: Bool) {
        if #available(iOS 13.0, *) {
            if hide {
                UIApplication.shared.keyWindow?.windowLevel = .statusBar
            } else {
                UIApplication.shared.keyWindow?.windowLevel = .normal
            }
        } else {
            let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
            if hide {
                if animation {
                    UIView.animate(withDuration: .animationDuration) {
                        statusBarWindow?.alpha = 0.0
                    }
                } else {
                    statusBarWindow?.alpha = 0.0
                }
            } else {
                if animation {
                    UIView.animate(withDuration: .animationDuration) {
                        statusBarWindow?.alpha = 1.0
                    }
                } else {
                    statusBarWindow?.alpha = 1.0
                }
            }
        }
    }
}
