//
//  ThreadShortInfo.swift
//  dvach
//
//  Created by Kirill Solovyov on 15/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import CoreData

struct ThreadShortInfo {
    var identifier: String
    var boardId: String? // Насаживается при кешировании
    let number: Int
    let comment: String?
    let subject: String?
    let thumbnailURL: String?
    var isFavourite: Bool
}

final class DBThreadShortInfo: NSManagedObject {
    @NSManaged var identifier: String
    @NSManaged var boardId: String?
    @NSManaged var threadNum: Int
    @NSManaged var comment: String?
    @NSManaged var subject: String?
    @NSManaged var thumbnailURL: String?
    @NSManaged var timestamp: TimeInterval
    @NSManaged var isFavourite: Bool // Для того, чтобы тред не попал в избранное при сохранении поста
}

// MARK: - Persistable

extension ThreadShortInfo: Persistable {
    
    typealias DBModel = DBThreadShortInfo
    
    static func from(_ dbModel: DBThreadShortInfo) -> ThreadShortInfo {
        return ThreadShortInfo(identifier: dbModel.identifier,
                               boardId: dbModel.boardId,
                               number: dbModel.threadNum,
                               comment: dbModel.comment,
                               subject: dbModel.subject,
                               thumbnailURL: dbModel.thumbnailURL,
                               isFavourite: dbModel.isFavourite)
    }
    
    func dbModel(from context: NSManagedObjectContext) -> DBThreadShortInfo {
        let dbModel = createModel(from: context)
        dbModel.identifier = identifier
        dbModel.boardId = boardId
        dbModel.threadNum = number
        dbModel.comment = comment
        dbModel.subject = subject
        dbModel.thumbnailURL = thumbnailURL
        dbModel.timestamp = Date().timeIntervalSince1970
        dbModel.isFavourite = isFavourite
        
        return dbModel
    }
}
