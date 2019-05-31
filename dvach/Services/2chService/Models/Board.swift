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
    let bumpLimit: Int
    let defaultName: String
    let enableDices: Bool
    let enableFlags: Bool
    let enableIcons: Bool
    let enableLikes: Bool
    let enableNames: Bool
    let enableOekaki: Bool
    let enablePosting: Bool
    let enableSage: Bool
    let enableShield: Bool
    let enableSubject: Bool
    let enableThreadTags: Bool
    let enableTrips: Bool
}

// MARK: - JSONParsable

extension Board: JSONParsable {
    
    static func from(json: JSON) -> Board? {
        guard let identifier = json["id"].string,
            let category = Category(rawValue: json["category"].stringValue),
            let name = json["name"].string,
            let pages = json["pages"].int,
            let bumpLimit = json["bump_limit"].int,
            let defaultName = json["default_name"].string,
            let enableDices = json["enable_dices"].int,
            let enableFlags = json["enable_flags"].int,
            let enableIcons = json["enable_icons"].int,
            let enableLikes = json["enable_likes"].int,
            let enableNames = json["enable_names"].int,
            let enableOekaki = json["enable_oekaki"].int,
            let enablePosting = json["enable_posting"].int,
            let enableSage = json["enable_sage"].int,
            let enableShield = json["enable_shield"].int,
            let enableSubject = json["enable_subject"].int,
            let enableThreadTags = json["enable_thread_tags"].int,
            let enableTrips = json["enable_trips"].int
        else { return nil }
        
        return Board(identifier: identifier,
                     category: category,
                     name: name,
                     pages: pages,
                     bumpLimit: bumpLimit,
                     defaultName: defaultName,
                     enableDices: enableDices.boolValue,
                     enableFlags: enableFlags.boolValue,
                     enableIcons: enableIcons.boolValue,
                     enableLikes: enableLikes.boolValue,
                     enableNames: enableNames.boolValue,
                     enableOekaki: enableOekaki.boolValue,
                     enablePosting: enablePosting.boolValue,
                     enableSage: enableSage.boolValue,
                     enableShield: enableShield.boolValue,
                     enableSubject: enableSubject.boolValue,
                     enableThreadTags: enableThreadTags.boolValue,
                     enableTrips: enableTrips.boolValue)
    }
}
