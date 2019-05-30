//
//  Board.swift
//  dvach
//
//  Created by Kirill Solovyov on 30/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Board {
    let identifier: String
    let category: Category
    let name: String
    let pages: Int
}

// MARK: - JSONParsable

extension Board: JSONParsable {
    
    static func from(json: JSON) -> Board? {
        guard let identifier = json["id"].string,
            let category = Category(rawValue: json["category"].stringValue),
            let name = json["name"].string,
            let pages = json["pages"].int else { return nil }
        
        return Board(identifier: identifier,
                     category: category,
                     name: name,
                     pages: pages)
    }
}
