//
//  Extention+UIViewController.swift
//  Receipt
//
//  Created by Kirill Solovyov on 24.02.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    var wrappedInNavigation: UIViewController {
        let leftItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backAction))
        leftItem.tintColor = .n1Gray
        navigationItem.leftBarButtonItem = leftItem
        
        let backItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(backAction))
        backItem.tintColor = .n1Gray
        navigationItem.backBarButtonItem = backItem

        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.n1Gray]
        navigationController.navigationBar.isTranslucent = false
        
        return navigationController
    }
    
    var wrappedInLargeNavigation: UIViewController {
        
        let backItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(backAction))
        backItem.tintColor = .n1Gray
        navigationItem.backBarButtonItem = backItem
        
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.n1Gray]
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.n1Gray]
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        
        return navigationController
    }
    
    // MARK: - Private
    
    @objc private func backAction() -> Void {
        dismiss(animated: true, completion: nil)
    }
}