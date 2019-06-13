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
        var boards = values.compactMap(Board.from)
        boards.append(contentsOf: getHiddenBoards())
        
        return Categories(boards: boards)
    }
}

// MARK: - Hidden Boards

extension Categories {
    static private var tyanach: Board {
        return Board(identifier: "dev",
                     category: Category.hidden,
                     name: "Тянач",
                     pages: nil,
                     boardSpeed: nil,
                     currentPage: nil,
                     bumpLimit: 500,
                     defaultName: "Аноним",
                     isDicesEnabled: false,
                     isFlagsEnabled: false,
                     isIconsEnabled: false,
                     isLikesEnabled: false,
                     isNamesEnabled: false,
                     isOekakiEnabled: false,
                     isPostingEnabled: true,
                     isSageEnabled: true,
                     isShieldEnabled: false,
                     isSubjectEnabled: true,
                     isThreadTagsEnabled: false,
                     isTripsEnabled: false,
                     additionalInfo: nil)
    }
    
    static private var asylum: Board {
        return Board(identifier: "asylum",
                     category: Category.hidden,
                     name: "Убежище",
                     pages: nil,
                     boardSpeed: nil,
                     currentPage: nil,
                     bumpLimit: 500,
                     defaultName: "Аноним",
                     isDicesEnabled: false,
                     isFlagsEnabled: false,
                     isIconsEnabled: false,
                     isLikesEnabled: false,
                     isNamesEnabled: true,
                     isOekakiEnabled: false,
                     isPostingEnabled: true,
                     isSageEnabled: true,
                     isShieldEnabled: false,
                     isSubjectEnabled: true,
                     isThreadTagsEnabled: false,
                     isTripsEnabled: true,
                     additionalInfo: nil)
    }
    
    static fileprivate func getHiddenBoards() -> [Board] {
        return [tyanach, asylum]
    }
}
