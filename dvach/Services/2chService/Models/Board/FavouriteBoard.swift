//
//  FavouriteBoard.swift
//  dvach
//
//  Created by Kirill Solovyov on 11/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import CoreData

struct BoardShortInfo {
    var identifier: String
    let category: Category
    let name: String
}

final class DBBoardShortInfo: NSManagedObject {
    @NSManaged var identifier: String
    @NSManaged var category: String
    @NSManaged var name: String
    @NSManaged var timestamp: Double // Дата добавления в избранное
}

// MARK: - Persistable

extension BoardShortInfo: Persistable {
    
    typealias DBModel = DBBoardShortInfo
    
    static func from(_ dbModel: DBBoardShortInfo) -> BoardShortInfo {
        return BoardShortInfo(identifier: dbModel.identifier,
                              category: Category(rawValue: dbModel.category) ?? .other,
                              name: dbModel.name)
    }
    
    func dbModel(from context: NSManagedObjectContext) -> DBBoardShortInfo {
        let dbModel = createModel(from: context)
        dbModel.identifier = identifier
        dbModel.category = category.rawValue
        dbModel.name = name
        dbModel.timestamp = Date().timeIntervalSince1970
        
        return dbModel
    }
}
