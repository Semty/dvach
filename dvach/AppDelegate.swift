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
import Alamofire

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
        
        let cookieProps = [
            HTTPCookiePropertyKey.domain: "2ch.hk",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "usercode_auth",
            HTTPCookiePropertyKey.value: "358fa225657f7ee4ac6b17881210cbe3"
        ]
        if let cookie = HTTPCookie(properties: cookieProps) {
            AF.session.configuration.httpCookieStorage?.setCookie(cookie)
        }
        
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

