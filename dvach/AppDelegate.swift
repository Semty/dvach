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
import Appodeal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Dependencies
    private let storage = Locator.shared.storage()
    
    // UI
    var window: UIWindow?

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GlobalUtils.setAudioInSilentModeOn()
        Appodeal.initialize(withApiKey: "b40e1fbb24bc14e50b0d75cddfee134d6abb4855df114e6d", types: [.nonSkippableVideo, .interstitial, .nativeAd])
        setupInitialViewController()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        storage.saveContext()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
            if (rootViewController.responds(to: #selector(MediaViewerController.canRotate))) {
                // Unlock landscape view orientations for this view controller
                return .allButUpsideDown;
            }
        }
        
        // Only allow portrait (standard behaviour)
        return .portrait;
    }
    
    // MARK: - Private
    
    private func setupInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController = InitialViewController()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}

