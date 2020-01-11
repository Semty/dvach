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
    
    // UI
    var window: UIWindow?

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GlobalUtils.setAudioInSilentModeOn()
        setupInitialViewController()
        setupNuke()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        storage.saveContext()
    }
    
    // MARK: - Private
    
    private func setupInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController = InitialViewController()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
    private func setupNuke() {
        ImagePipeline.shared = ImagePipeline {
            $0.isDataCachingForOriginalImageDataEnabled = false
            $0.isDataCachingForProcessedImagesEnabled = true
        }
    }
}

