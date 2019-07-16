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
        categoriesViewController.tabBarItem.image = #imageLiteral(resourceName: "boldLight.png").withRenderingMode(.alwaysTemplate)
        
        let favouritesViewController = FavouritesViewController()
        favouritesViewController.title = "Избранное"
        favouritesViewController.tabBarItem.image = #imageLiteral(resourceName: "star.png").withRenderingMode(.alwaysTemplate)
        
        let settingsViewController = SettingsViewController()
        settingsViewController.title = "Еще"
        settingsViewController.tabBarItem.image = #imageLiteral(resourceName: "moreTab").withRenderingMode(.alwaysTemplate)
        
        viewControllers = [categoriesViewController.wrappedInLargeNavigation,
                           favouritesViewController.wrappedInLargeNavigation,
                           settingsViewController.wrappedInLargeNavigation]
        tabBar.barTintColor = .white
        tabBar.tintColor = .n1Gray
    }
}
