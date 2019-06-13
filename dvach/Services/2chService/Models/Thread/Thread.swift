//
//  Thread.swift
//  dvach
//
//  Created by Ruslan Timchenko on 31/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Thread {
    let comment: String?
    let lastHit: Int? // Как я понял, это таймстамп последней активности в треде
    let num: Int
    let postsCount: Int
    let score: Double?
    let subject: String?
    let timestamp: Int? // А вот это должно быть время создания треда
    let views: Int?
    let filesCount: Int?
    let titlePost: Post?
    let threeLastPosts: [Post]?
    let additionalInfo: ThreadAdditionalInfo?
}

// MARK: - JSONParsable

extension Thread: JSONParsable {
    
    static func from(json: JSON) -> Thread? {
        guard let postsCount = json["posts_count"].int else { return nil }
        
        var num: Int
        
        if let numString = json["num"].string {
            num = Int(numString) ?? -1
        } else if let numString = json["thread_num"].string {
            num = Int(numString) ?? -1
        } else {
            return nil
        }
        
        let comment = json["comment"].string
        let lastHit = json["lasthit"].int
        let subject = json["subject"].string
        let timestamp = json["timestamp"].int
        
        let score = json["score"].double
        let views = json["views"].int
        let filesCount = json["files_count"].int
        let additionalInfo = ThreadAdditionalInfo.from(json: json)
        
        let postsArray = json["posts"].array
        var posts = postsArray?.compactMap(Post.from)
        
        let titlePost = posts?.removeFirst()
        let threeLastPosts = posts
        
        return Thread(comment: comment,
                      lastHit: lastHit,
                      num: num,
                      postsCount: postsCount,
                      score: score,
                      subject: subject,
                      timestamp: timestamp,
                      views: views,
                      filesCount: filesCount,
                      titlePost: titlePost,
                      threeLastPosts: threeLastPosts,
                      additionalInfo: additionalInfo)
    }
}
