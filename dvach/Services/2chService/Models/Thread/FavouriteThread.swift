//
//  FavouriteThread.swift
//  dvach
//
//  Created by Kirill Solovyov on 15/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import CoreData

struct FavouriteThread {
    var identifier: String
    let boardId: String
    var number: Int
    let comment: String
    let subject: String
    let thumbnailURL: String
    let timestamp: TimeInterval
}

final class DBFavouriteThread: NSManagedObject {
    @NSManaged var identifier: String
    @NSManaged var boardId: String
    @NSManaged var threadNum: Int
    @NSManaged var comment: String
    @NSManaged var subject: String
    @NSManaged var thumbnailURL: String
    @NSManaged var timestamp: TimeInterval
}

// MARK: - Persistable

extension FavouriteThread: Persistable {
    
    typealias DBModel = DBFavouriteThread
    
    static func from(_ dbModel: DBFavouriteThread) -> FavouriteThread {
        return FavouriteThread(identifier: dbModel.identifier,
                               boardId: dbModel.boardId,
                               number: dbModel.threadNum,
                               comment: dbModel.comment,
                               subject: dbModel.subject,
                               thumbnailURL: dbModel.thumbnailURL,
                               timestamp: dbModel.timestamp)
    }
    
    func dbModel(from context: NSManagedObjectContext) -> DBFavouriteThread {
        let dbModel = createModel(from: context)
        dbModel.identifier = identifier
        dbModel.boardId = boardId
        dbModel.threadNum = number
        dbModel.comment = comment
        dbModel.subject = subject
        dbModel.thumbnailURL = thumbnailURL
        dbModel.timestamp = timestamp
        
        return dbModel
    }
}
