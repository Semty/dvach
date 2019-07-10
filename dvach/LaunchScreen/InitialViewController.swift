//
//  InitialViewController.swift
//  dvach
//
//  Created by Ruslan Timchenko on 10/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

public protocol LaunchAnimationViewControllerDelegate: class {
    func endSplashScreen()
}

final class InitialViewController: UIViewController, LaunchAnimationViewControllerDelegate {
    
    private var rootViewController: UIViewController?
    
    override var prefersStatusBarHidden: Bool {
        switch rootViewController {
        case is LaunchAnimationViewController:
            return true
        case is RootTabBarController:
            return topViewControllerWithRootViewController(rootViewController: rootViewController)?.prefersStatusBarHidden ?? true
        default:
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateSplashScreen()
    }
    
    // MARK: - Transition Handler
    
    private func initiateSplashScreen() {
        let splashViewController = LaunchAnimationViewController()
        splashViewController.delegate = self
        
        rootViewController = splashViewController
        
        splashViewController.willMove(toParent: self)
        addChild(splashViewController)
        view.insertSubview(splashViewController.view,
                           at: 0)
        splashViewController.didMove(toParent: self)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - LaunchAnimationViewControllerDelegate
    
    public func endSplashScreen() {
        let rootTabBarController = RootTabBarController()
        
        rootTabBarController.willMove(toParent: self)
        addChild(rootTabBarController)
        
        if let rootViewController = rootViewController {
            
            self.rootViewController = rootTabBarController
            rootViewController.willMove(toParent: nil)
            
            willMove(toParent: nil)
            
            transition(from: rootViewController,
                       to: rootTabBarController,
                       duration: 0.55,
                       options: [.transitionCrossDissolve, .curveEaseOut],
                       animations: { () -> Void in
                        
            }, completion: { _ in
                rootTabBarController.didMove(toParent: self)
                rootViewController.removeFromParent()
                rootViewController.didMove(toParent: nil)
            })
            
        } else {
            
            rootViewController = rootTabBarController
            view.addSubview(rootTabBarController.view)
            rootTabBarController.didMove(toParent: self)
        }
        setNeedsStatusBarAppearanceUpdate()
    }
}
