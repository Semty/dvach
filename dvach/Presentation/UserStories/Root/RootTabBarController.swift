//
//  RootTabBarController.swift
//  NBAStats
//
//  Created by Kirill Solovyov on 12/04/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class RootTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewControllers = []
        tabBar.barTintColor = .white
        tabBar.tintColor = .n6Green
    }
}
