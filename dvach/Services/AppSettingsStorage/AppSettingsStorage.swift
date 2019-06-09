//
//  AppSettingsStorage.swift
//  FatFood
//
//  Created by Kirill Solovyov on 20/01/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IAppSettingsStorage: class {
    var lastUpdatedConfigDate: TimeInterval { get set }
}

private extension String {
    static let lastUpdatedConfigDateKey = "lastUpdatedConfigDate"
}

final class AppSettingsStorage: IAppSettingsStorage {
    
    var lastUpdatedConfigDate: TimeInterval {
        get {
            return self[.lastUpdatedConfigDateKey] as? TimeInterval ?? 0
        }
        set {
            self[.lastUpdatedConfigDateKey] = newValue
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
