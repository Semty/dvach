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
        return FireBaseService()
    }
    
    /// сервис для работы с User Defaults
    func appSettingsStorage() -> IAppSettingsStorage {
        return AppSettingsStorage()
    }
    
    /// сервис 2ch
    func dvachService() -> IDvachService {
        return DvachService(requestManager: requestManager(), storage: storage())
    }
    
    /// сервис для подгрузки и обновления конфига
    func configService() -> IConfigService {
        return ConfigService(firebaseService: firebaseService(),
                             appSettingsStorage: appSettingsStorage())
    }
    
    func profanityCensor() -> IProfanityCensor {
        return ProfanityCensor()
    }
    
    func authService() -> IAuthService {
        return AuthService()
    }
    
    func accountUpdater() -> IUserAccountUpdater {
        return UserAccountUpdater.shared
    }
    
    func accountService() -> IUserAccountService {
        return UserAccountService()
    }
}
