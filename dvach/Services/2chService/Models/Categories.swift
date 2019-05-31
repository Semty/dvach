//
//  Categories.swift
//  dvach
//
//  Created by Kirill Solovyov on 30/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Categories: JSONParsable {
    let boards: [Board]
    
    // MARK: - JSONParsable
    
    static func from(json: JSON) -> Categories? {
        guard let categories = json.dictionary else { return nil }
        let values = categories.flatMap { $0.value.arrayValue }
        let boards = values.compactMap(Board.from)
        
        return Categories(boards: boards)
    }
}
