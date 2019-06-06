//
//  AppDelegate.swift
//  dvach
//
//  Created by Kirill Solovyov on 29/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Dependencies
    private let storage = Locator.shared.storage()
    private lazy var firebaseService = Locator.shared.configService()
    
    // UI
    var window: UIWindow?

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        firebaseService.updateConfig { [weak self] in
            DispatchQueue.main.async {
                self?.setupInitialViewController()
            }
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        storage.saveContext()
    }
    
    // MARK: - Private
    
    private func setupInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: RootTabBarController.className) as! RootTabBarController
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}

