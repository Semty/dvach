//
//  Extension+UITabBarController.swift
//  dvach
//
//  Created by Ruslan Timchenko on 15/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UITabBarController {
    override open var childForStatusBarHidden: UIViewController? {
        return selectedViewController
    }
}
