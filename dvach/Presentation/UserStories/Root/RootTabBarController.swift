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
        
        let categoriesViewController = CategoriesViewController()
        categoriesViewController.title = "Категории"
        let favouritesViewController = FavouritesViewController()
        favouritesViewController.title = "Избранное"
        let settingsViewController = SettingsViewController()
        settingsViewController.title = "Еще"
        
        viewControllers = [categoriesViewController.wrappedInLargeNavigation,
                           favouritesViewController.wrappedInNavigation,
                           settingsViewController]
        tabBar.barTintColor = .white
        tabBar.tintColor = .n1Gray
    }
}
