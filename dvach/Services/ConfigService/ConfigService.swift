//
//  ConfigService.swift
//  dvach
//
//  Created by Kirill Solovyov on 06/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

private extension TimeInterval {
    static let invalidationTime: TimeInterval = 60 * 60 * 24 // day
}

protocol IConfigService {
    
    /// Обновляет конфиг
    func updateConfig(completion: @escaping () -> Void)
    
    /// Читает конфиг из сохраненного файла, либо из дефолтного конфига в бандле
    func readLocalConfig() -> JSON
    
    /// Обновляет конфиг с ненормативной лексикой
    func updateBadWordsConfig(completion: @escaping () -> Void)
    
    /// Читает конфиг с ненормативной лексикой из сохраненного файла, либо из дефолтного конфига в бандле
    func readBadWordsConfig() -> JSON
}

final class ConfigService: IConfigService {
    
    // Dependencies
    private let firebaseService: IFirebaseService
    private let appSettingsStorage: IAppSettingsStorage
    
    // MARK: - Initialization
    
    init(firebaseService: IFirebaseService, appSettingsStorage: IAppSettingsStorage) {
        self.firebaseService = firebaseService
        self.appSettingsStorage = appSettingsStorage
    }
    
    // MARK: - Private
    
    private var configURl: URL {
        let url = try? FileManager.default.url(for: .documentDirectory,
                                              in: .userDomainMask,
                                              appropriateFor: nil,
                                              create: false)
        return url?.appendingPathComponent("config.json") ?? URL(fileURLWithPath: "")
    }
    
    private var badWordsConfigURl: URL {
        let url = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        return url?.appendingPathComponent("badWordsConfig.json") ?? URL(fileURLWithPath: "")
    }
    
    private func saveConfig(json: JSON, to localURL: URL) {
        do {
            let data = json.description.data(using: .utf8)
            try data?.write(to: localURL, options: .noFileProtection)
        } catch {
            print(error)
        }
    }
    
    // MARK: - IConfigService
    
    func updateConfig(completion: @escaping () -> Void) {
        // Обновляем конфиг только раз в день
        guard Date().timeIntervalSince1970 - appSettingsStorage.lastUpdatedConfigDate > .invalidationTime else {
            completion()
            return
        }
        
        firebaseService.observeRemoteDatabase(child: .config) { [weak self] json, error in
            guard let self = self, let json = json, !json.isEmpty else {
                completion()
                return
            }
            self.appSettingsStorage.lastUpdatedConfigDate = Date().timeIntervalSince1970
            self.saveConfig(json: json, to: self.configURl)
            completion()
        }
    }
    
    func readLocalConfig() -> JSON {
        var handler: FileHandle?
        // Сначала стараемся считать конфиг "свежий" обновленный по сети
        if let documentsHandler = FileHandle(forReadingAtPath: configURl.path) {
            handler = documentsHandler
        } else if let path = Bundle.main.path(forResource: "config", ofType: "json"),
            let defaultHandler = FileHandle(forReadingAtPath: path) {
            // В случае, если его там нет - берем дефолтный из бандла
            handler = defaultHandler
        }
        
        guard let data = handler?.readDataToEndOfFile() else { return JSON() }
        return JSON(data)
    }
    
    func updateBadWordsConfig(completion: @escaping () -> Void) {
        firebaseService.observeRemoteDatabase(child: .badWordsConfig) { [weak self] json, error in
            guard let self = self, let json = json else {
                completion()
                return
            }

            self.saveConfig(json: json, to: self.badWordsConfigURl)
            completion()
        }
    }
    
    func readBadWordsConfig() -> JSON {
        var handler: FileHandle?
        // Сначала стараемся считать конфиг "свежий" обновленный по сети
        if let documentsHandler = FileHandle(forReadingAtPath: badWordsConfigURl.path) {
            handler = documentsHandler
        } else if let path = Bundle.main.path(forResource: "badWordsConfig", ofType: "json"),
            // В случае, если его там нет - берем дефолтный из бандла
            let defaultHandler = FileHandle(forReadingAtPath: path) {
            handler = defaultHandler
        }
        
        guard let data = handler?.readDataToEndOfFile() else { return JSON() }
        return JSON(data)
    }
}
