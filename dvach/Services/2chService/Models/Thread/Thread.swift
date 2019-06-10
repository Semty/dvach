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
    let comment: String
    let lastHit: Int // Как я понял, это таймстамп последней активности в треде
    let num: Int
    let postsCount: Int
    let score: Double?
    let subject: String
    let timestamp: Int // А вот это должно быть время создания треда
    let views: Int?
    let additionalInfo: ThreadAdditionalInfo?
}

// MARK: - JSONParsable

extension Thread: JSONParsable {
    static func from(json: JSON) -> Thread? {
        guard let comment = json["comment"].string,
            let lastHit = json["lasthit"].int,
            let numString = json["num"].string,
            let num = Int(numString),
            let postsCount = json["posts_count"].int,
            let subject = json["subject"].string,
            let timestamp = json["timestamp"].int else { return nil }
        
        let score = json["score"].double
        let views = json["views"].int
        let additionalInfo = ThreadAdditionalInfo.from(json: json)
        
        return Thread(comment: comment,
                      lastHit: lastHit,
                      num: num,
                      postsCount: postsCount,
                      score: score,
                      subject: subject,
                      timestamp: timestamp,
                      views: views,
                      additionalInfo: additionalInfo)
    }
}
