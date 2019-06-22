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
    var nsfwBannersAllowed: Bool { get set }
}

private extension String {
    static let lastUpdatedConfigDateKey = "lastUpdatedConfigDate"
    static let nsfwBannersAllowed = "nsfwBannersAllowed"
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
    
    var nsfwBannersAllowed: Bool {
        get {
            return self[.nsfwBannersAllowed] as? Bool ?? true
        }
        set {
            self[.nsfwBannersAllowed] = newValue
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
