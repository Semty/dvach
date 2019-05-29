//
//  AppSettingsStorage.swift
//  FatFood
//
//  Created by Kirill Solovyov on 20/01/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IAppSettingsStorage: class {
    var lastUpdatedStorageDate: TimeInterval { get set }
}

private extension String {
    static let lastUpdatedStorageDateKey = "lastUpdatedStorageDateKey"
}

final class AppSettingsStorage: IAppSettingsStorage {
    
    var lastUpdatedStorageDate: TimeInterval {
        get {
            return self[.lastUpdatedStorageDateKey] as? TimeInterval ?? 0
        }
        set {
            self[.lastUpdatedStorageDateKey] = newValue
        }
    }
    
    
    // MARK: - Private
    
    private subscript(key: String) -> Any? {
        get {
            return UserDefaults.standard.object(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}
