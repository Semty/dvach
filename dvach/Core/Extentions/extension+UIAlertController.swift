//
//  extension+UIAlertController.swift
//  dvach
//
//  Created by Ruslan Timchenko on 26/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UIAlertController {
    static func simpleAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(okAction)
        return alert
    }
}
