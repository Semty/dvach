//
//  ConfigService.swift
//  dvach
//
//  Created by Kirill Solovyov on 06/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IConfigService {
    
    /// Обновляет конфиг
    func updateConfig(completion: @escaping () -> Void)
    
    /// Читает конфиг из сохраненного файла, либо из дефолтного конфига в бандле
    func readLocalConfig() -> JSON
}

final class ConfigService: IConfigService {
    
    // Dependencies
    private let firebaseService: IFirebaseService
    
    // MARK: - Initialization
    
    init(firebaseService: IFirebaseService) {
        self.firebaseService = firebaseService
    }
    
    // MARK: - Private
    
    private var configURl: URL {
        let url = try? FileManager.default.url(for: .documentDirectory,
                                              in: .userDomainMask,
                                              appropriateFor: nil,
                                              create: false)
        return url?.appendingPathComponent("config.json") ?? URL(fileURLWithPath: "")
    }
    
    private func saveConfigToLocalFile(json: JSON) {
        do {
            let data = json.description.data(using: .utf8)
            try data?.write(to: configURl, options: .noFileProtection)
        } catch {
            print(error)
        }
    }
    
    // MARK: - IConfigService
    
    func updateConfig(completion: @escaping () -> Void) {
        firebaseService.observeRemoteDatabase { [weak self] json, error in
            guard let json = json else {
                print(error ?? "ConfigService")
                completion()
                return
            }
            
            self?.saveConfigToLocalFile(json: json)
            completion()
        }
    }
    
    func readLocalConfig() -> JSON {
        var handler: FileHandle?
        // Сначала стараемся считать конфиг "свежий" обновленный по сети
        if let documentsHandler = FileHandle(forReadingAtPath: configURl.path) {
            handler = documentsHandler
        } else if let path = Bundle.main.path(forResource: "config", ofType: "json"),
            // В случае, если его там нет - берем дефолтный из бандла
            let defaultHandler = FileHandle(forReadingAtPath: path) {
            handler = defaultHandler
        }
        
        guard let data = handler?.readDataToEndOfFile() else { return JSON() }
        return JSON(data)
    }
}
