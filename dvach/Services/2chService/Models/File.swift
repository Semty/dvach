//
//  Files.swift
//  dvach
//
//  Created by Ruslan Timchenko on 31/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

enum FileType: Int {
    case jpg = 1
    case png = 2
    case gif = 4
    case webm = 6
    case mp4 = 10
    case unknown = -1 // мало ли что может придти
}

struct File {
    let displayName: String
    let fullName: String
    let height: Int
    let md5: String
    let name: String
    let isNSFW: Bool // Из того, что я на данный момент видел, откровенный прон не помечен в 99% случаев данным флагом
    let path: String
    let size: Int
    let thumbnail: String
    let tnHeight: Int
    let tnWidth: Int
    let type: FileType
    let width: Int
}

// MARK: - JSONParsable

extension File: JSONParsable {
    static func from(json: JSON) -> File? {
        guard let displayName = json["displayname"].string,
            let fullName = json["fullname"].string,
            let height = json["height"].int,
            let md5 = json["md5"].string,
            let name = json["name"].string,
            let isNSFW = json["nsfw"].int,
            let path = json["path"].string,
            let size = json["size"].int,
            let thumbnail = json["thumbnail"].string,
            let tnHeight = json["tn_height"].int,
            let tnWidth = json["tn_width"].int,
            let type = json["type"].int,
            let width = json["width"].int else { return nil }
        
        return File(displayName: displayName,
                    fullName: fullName,
                    height: height,
                    md5: md5,
                    name: name,
                    isNSFW: isNSFW.boolValue,
                    path: path,
                    size: size,
                    thumbnail: thumbnail,
                    tnHeight: tnHeight,
                    tnWidth: tnWidth,
                    type: FileType(rawValue: type) ?? .unknown,
                    width: width)
    }
}
