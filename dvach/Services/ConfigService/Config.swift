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
    private var json: JSON {
        return configService.readLocalConfig()
    }
    
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
    
    var news: String {
        return json["news"].stringValue.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    var rules: String {
        return json["rules"].stringValue.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    var nsfwFilter: (nsfwBorder: Double, sfwBorder: Double) {
        let dict = json["nsfwFilter"].dictionaryValue
        return (dict["nsfwPredictionBorder"]?.double ?? 0.49,
                dict["sfwPredictionBorder"]?.double ?? 0.98)
    }
    
    var badWordsVersion: Int {
        return json["badWordsVersion"].intValue
    }
}
