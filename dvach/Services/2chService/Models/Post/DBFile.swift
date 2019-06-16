//
//  DBFile.swift
//  dvach
//
//  Created by Kirill Solovyov on 16/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import CoreData

final class DBFile: NSManagedObject {
    @NSManaged var identifier: String
    @NSManaged var displayName: String?
    @NSManaged var fullName: String?
    @NSManaged var height: Int
    @NSManaged var md5: String?
    @NSManaged var name: String
    @NSManaged var isNSFW: Bool
    @NSManaged var path: String
    @NSManaged var size: Int
    @NSManaged var thumbnail: String
    @NSManaged var tnHeight: Int
    @NSManaged var tnWidth: Int
    @NSManaged var type: Int
    @NSManaged var width: Int
}

// MARK: - Persistable

extension File: Persistable {
    
    typealias DBModel = DBFile

    static func from(_ dbModel: DBFile) -> File {
        return File(identifier: dbModel.identifier,
                    displayName: dbModel.displayName,
                    fullName: dbModel.fullName,
                    height: dbModel.height,
                    md5: dbModel.md5,
                    name: dbModel.name,
                    isNSFW: dbModel.isNSFW,
                    path: dbModel.path,
                    size: dbModel.size,
                    thumbnail: dbModel.thumbnail,
                    tnHeight: dbModel.tnHeight,
                    tnWidth: dbModel.tnWidth,
                    type: FileType(rawValue: dbModel.type) ?? .unknown,
                    width: dbModel.width)
    }
    
    func dbModel(from context: NSManagedObjectContext) -> DBFile {
        let dbModel = createModel(from: context)
        dbModel.identifier = identifier
        dbModel.displayName = displayName
        dbModel.fullName = fullName
        dbModel.height = height
        dbModel.md5 = md5
        dbModel.name = name
        dbModel.isNSFW = isNSFW ?? false
        dbModel.path = path
        dbModel.size = size
        dbModel.thumbnail = thumbnail
        dbModel.tnHeight = tnHeight
        dbModel.tnWidth = tnWidth
        dbModel.type = type.rawValue
        dbModel.width = width
        
        return dbModel
    }
}
