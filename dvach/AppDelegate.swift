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
        //Appodeal.setLogLevel(.debug)
        Appodeal.setAutocache(false, types: .nativeAd)
        Appodeal.initialize(withApiKey: "9a73fae9d72048b1aa143954ca98dc4c3c94576b028e681d", types: [.nativeAd], hasConsent: false)
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

