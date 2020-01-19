//
//  NotificationName.swift
//  dvach
//
//  Created by Ruslan Timchenko on 19.01.2020.
//  Copyright © 2020 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}
