//
//  Post.swift
//  dvach
//
//  Created by Ruslan Timchenko on 06/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Post {
    var identifier: String
    let isBanned: Bool
    let isClosed: Bool
    let comment: String
    let date: String
    let email: String
    let isEndless: Bool
    let files: [File]
    let lastHit: Int
    let name: String
    let num: Int
    let isOp: Bool
    let parent: String
    let sticky: Bool
    let subject: String
    let time: TimeInterval
    let trip: String
    let tripType: String?
    let likes: Int?
    let dislikes: Int?
    let filesCount: Int?
    let postsCount: Int?
    let tags: String?
    let uniquePosters: String? // В API видел число 110 один раз в строке
    var threadInfo: ThreadShortInfo? // Насаживается при кешировании, для того, чтобы открыть этот тред
}

// MARK: - JSONParsable

extension Post: JSONParsable {
    
    static func from(json: JSON) -> Post? {
        guard let isBanned = json["banned"].int,
            let isClosed = json["closed"].int,
            let comment = json["comment"].string,
            let date = json["date"].string,
            let email = json["email"].string,
            let isEndless = json["endless"].int,
            let filesArray = json["files"].array,
            let lastHit = json["lasthit"].int,
            let name = json["name"].string,
            let numString = json["num"].string,
            let num = Int(numString),
            let isOp = json["op"].int,
            let parent = json["parent"].string,
            let sticky = json["sticky"].int,
            let subject = json["subject"].string,
            let timestamp = json["timestamp"].double,
            let trip = json["trip"].string else { return nil }
        
        let tripType = json["trip_type"].string
        let likes = json["likes"].int
        let dislikes = json["dislikes"].int
        let filesCount = json["files_count"].int
        let postsCount = json["posts_count"].int
        let tags = json["tags"].string
        let uniquePosters = json["unique_posters"].string
        
        let files = filesArray.compactMap(File.from)
        
        return Post(identifier: UUID().uuidString,
                    isBanned: isBanned.boolValue,
                    isClosed: isClosed.boolValue,
                    comment: comment,
                    date: date,
                    email: email,
                    isEndless: isEndless.boolValue,
                    files: files,
                    lastHit: lastHit,
                    name: name,
                    num: num,
                    isOp: isOp.boolValue,
                    parent: parent,
                    sticky: sticky.boolValue,
                    subject: subject,
                    time: timestamp,
                    trip: trip,
                    tripType: tripType,
                    likes: likes,
                    dislikes: dislikes,
                    filesCount: filesCount,
                    postsCount: postsCount,
                    tags: tags,
                    uniquePosters: uniquePosters,
                    threadInfo: nil)
    }
}
