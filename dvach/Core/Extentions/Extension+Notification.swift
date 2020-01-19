//
//  Extension+Notification.swift
//  dvach
//
//  Created by Ruslan Timchenko on 19.01.2020.
//  Copyright © 2020 Kirill Solovyov. All rights reserved.
//

import Foundation

extension Notification {
    
    func keyboardHeight() -> CGFloat? {
        if let keyboardFrame: NSValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            return keyboardHeight
        } else {
            return nil
        }
    }
    
    func isKeyboardBelongsToOurApp() -> Bool? {
        if let keyboardSource = userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber {
            return keyboardSource.boolValue
        }
        return nil
    }
}
