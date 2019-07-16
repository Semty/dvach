//
//  Extension+UINavigationController.swift
//  dvach
//
//  Created by Ruslan Timchenko on 15/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UINavigationController {
    override open var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
}
