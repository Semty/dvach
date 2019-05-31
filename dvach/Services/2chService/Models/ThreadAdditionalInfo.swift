//
//  ThreadAdditionalInfo.swift
//  dvach
//
//  Created by Ruslan Timchenko on 31/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ThreadAdditionalInfo {
    let isBanned: Bool
    let isClosed: Bool
    let date: String
    let email: String
    let isEndless: Bool
    let files: [File]
    let filesCount: Int
    let name: String
    /// op - Автор поста. Данная переменная показывает, автор ли поста написал сообщение
    let isOp: Bool
    let parent: String
    let sticky: Int // до конца не понял, что данная переменная значит
    let tags: String
    let trip: String
}

// MARK: - JSONParsable

extension ThreadAdditionalInfo: JSONParsable {
    static func from(json: JSON) -> ThreadAdditionalInfo? {
        guard let isBanned = json["banned"].int,
            let isClosed = json["closed"].int,
            let date = json["date"].string,
            let email = json["email"].string,
            let isEndless = json["endless"].int,
            let filesArray = json["files"].array,
            let filesCount = json["files_count"].int,
            let name = json["name"].string,
            let isOp = json["op"].int,
            let parent = json["parent"].string,
            let sticky = json["sticky"].int,
            let tags = json["tags"].string,
            let trip = json["trip"].string else { return nil }
        
        let files = filesArray.compactMap(File.from)
        
        return ThreadAdditionalInfo(isBanned: isBanned.boolValue,
                                    isClosed: isClosed.boolValue,
                                    date: date,
                                    email: email,
                                    isEndless: isEndless.boolValue,
                                    files: files,
                                    filesCount: filesCount,
                                    name: name,
                                    isOp: isOp.boolValue,
                                    parent: parent,
                                    sticky: sticky,
                                    tags: tags,
                                    trip: trip)
    }
}
