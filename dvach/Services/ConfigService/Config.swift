//
//  Config.swift
//  dvach
//
//  Created by Kirill Solovyov on 06/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

let Config = ConfigHandler()

final class ConfigHandler {
    
    // Dependencies
    private let configService = Locator.shared.configService()
    
    // Properties
    private lazy var json = configService.readLocalConfig()["config"]
    
    // MARK: - Public
    
    var blocksOrder: [Category]? {
        let dict = json["boardsOrder"].dictionaryValue
        let items: [(Category, Int)] = Category.list.compactMap {
            guard let index = dict[$0.rawValue]?.int, index >= 0 else { return nil }
            return ($0, index)
        }
        guard !items.isEmpty else { return nil }
        
        return items.sorted(by: { $0.1 < $1.1 }).map { $0.0 }
    }
}
