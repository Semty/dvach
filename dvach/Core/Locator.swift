//
//  Locator.swift
//  Receipt
//
//  Created by Kirill Solovyov on 25.02.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

final class Locator {
    
    static let shared = Locator()
    private init() {}
    
    /// Хранилище
    func storage() -> IStorage {
        return Storage()
    }
    
    /// фабрика UI компонентов
    func componentsFactory() -> IComponentsFactory {
        return ComponentsFactory()
    }
    
    /// сервис работы с реквестами и сетью
    func requestManager() -> IRequestManager {
        return RequestManager()
    }
    
    /// сервис для работы с Firebase
    func firebaseService() -> IFirebaseService {
        return FireBaseService.shared
    }
    
    /// сервис для работы с User Defaults
    func appSettingsStorage() -> IAppSettingsStorage {
        return AppSettingsStorage()
    }
}
