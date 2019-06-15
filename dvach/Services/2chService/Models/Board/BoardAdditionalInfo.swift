//
//  BoardAdditionalInfo.swift
//  dvach
//
//  Created by Ruslan Timchenko on 31/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BoardAdditionalInfo {
    let boardInfo: String
    let boardInfoOuter: String
    let isImagesEnabled: Bool
    let isVideoEnabled: Bool
    let filter: String?
    let maxComment: Int
    let maxFileSize: Int // В килобайтах, например: 40960
    let threads: [Thread]
}

// MARK: - JSONParsable

extension BoardAdditionalInfo: JSONParsable {
    
    static func from(json: JSON) -> BoardAdditionalInfo? {
        guard let boardInfo = json["BoardInfo"].string,
            let boardInfoOuter = json["BoardInfoOuter"].string,
            let isImagesEnabled = json["enable_images"].int,
            let isVideoEnabled = json["enable_video"].int,
            let maxComment = json["max_comment"].int,
            let maxFileSize = json["max_files_size"].int,
            let threadsArray = json["threads"].array else { return nil }
        
        let filter = json["filter"].string
        let threads = threadsArray.compactMap(Thread.from)
        
        return BoardAdditionalInfo(boardInfo: boardInfo,
                                   boardInfoOuter: boardInfoOuter,
                                   isImagesEnabled: isImagesEnabled.boolValue,
                                   isVideoEnabled: isVideoEnabled.boolValue,
                                   filter: filter,
                                   maxComment: maxComment,
                                   maxFileSize: maxFileSize,
                                   threads: threads)
    }
}
