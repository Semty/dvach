//
//  DBPost.swift
//  dvach
//
//  Created by Kirill Solovyov on 16/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import CoreData

final class DBPost: NSManagedObject {
    @NSManaged var identifier: String
    @NSManaged var isBanned: Bool
    @NSManaged var isClosed: Bool
    @NSManaged var comment: String
    @NSManaged var date: String
    @NSManaged var email: String
    @NSManaged var isEndless: Bool
    @NSManaged var files: Set<DBFile>
    @NSManaged var lastHit: Int
    @NSManaged var name: String
    @NSManaged var num: Int
    @NSManaged var isOp: Bool
    @NSManaged var parent: String
    @NSManaged var sticky: Bool
    @NSManaged var subject: String
    @NSManaged var time: TimeInterval
    @NSManaged var trip: String
    @NSManaged var tripType: String?
    @NSManaged var likes: Int
    @NSManaged var dislikes: Int
    @NSManaged var filesCount: Int
    @NSManaged var postsCount: Int
    @NSManaged var tags: String?
    @NSManaged var uniquePosters: String?
    @NSManaged var timestamp: TimeInterval
    @NSManaged var threadInfo: DBThreadShortInfo
}

// MARK: - Persistable

extension Post: Persistable {
    
    typealias DBModel = DBPost

    static func from(_ dbModel: DBPost) -> Post {
        let files = dbModel.files.map(File.from)
        return Post(identifier: dbModel.identifier,
                    isBanned: dbModel.isBanned,
                    isClosed: dbModel.isClosed,
                    comment: dbModel.comment,
                    date: dbModel.date,
                    email: dbModel.email,
                    isEndless: dbModel.isEndless,
                    files: files,
                    lastHit: dbModel.lastHit,
                    name: dbModel.name,
                    num: dbModel.num,
                    isOp: dbModel.isOp,
                    parent: dbModel.parent,
                    sticky: dbModel.sticky,
                    subject: dbModel.subject,
                    time: dbModel.timestamp,
                    trip: dbModel.trip,
                    tripType: dbModel.tripType,
                    likes: dbModel.likes,
                    dislikes: dbModel.dislikes,
                    filesCount: dbModel.filesCount,
                    postsCount: dbModel.postsCount,
                    tags: dbModel.tags,
                    uniquePosters: dbModel.uniquePosters,
                    threadInfo: ThreadShortInfo.from(dbModel.threadInfo))
    }
    
    func dbModel(from context: NSManagedObjectContext) -> DBPost {
        let dbModel = createModel(from: context)
        let dbFiles = files.map { $0.dbModel(from: context) }
        dbModel.identifier = identifier
        dbModel.isBanned = isBanned
        dbModel.isClosed = isClosed
        dbModel.comment = comment
        dbModel.date = date
        dbModel.email = date
        dbModel.isEndless = isEndless
        dbModel.files = Set(dbFiles)
        dbModel.lastHit = lastHit
        dbModel.name = name
        dbModel.num = num
        dbModel.isOp = isOp
        dbModel.parent = parent
        dbModel.sticky = sticky
        dbModel.subject = subject
        dbModel.time = time
        dbModel.trip = trip
        dbModel.tripType = tripType
        dbModel.likes = likes ?? 0
        dbModel.dislikes = dislikes ?? 0
        dbModel.filesCount = filesCount ?? 0
        dbModel.postsCount = postsCount ?? 0
        dbModel.tags = tags
        dbModel.uniquePosters = uniquePosters
        dbModel.timestamp = Date().timeIntervalSince1970
        
        if let threadInfo = threadInfo {
            dbModel.threadInfo = threadInfo.dbModel(from: context)
        }
        
        return dbModel
    }
}
