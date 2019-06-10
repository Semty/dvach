//
//  FavouriteBoard.swift
//  dvach
//
//  Created by Kirill Solovyov on 11/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import CoreData

struct FavouriteBoard {
    var identifier: String
    let category: Category
    let name: String
    let timestamp: TimeInterval // Дата добавления в избранное
}

final class DBFavouriteBoard: NSManagedObject {
    @NSManaged var identifier: String
    @NSManaged var category: String
    @NSManaged var name: String
    @NSManaged var timestamp: Double
}

// MARK: - Persistable

extension FavouriteBoard: Persistable {
    
    typealias DBModel = DBFavouriteBoard
    
    static func from(_ dbModel: DBFavouriteBoard) -> FavouriteBoard {
        return FavouriteBoard(identifier: dbModel.identifier,
                              category: Category(rawValue: dbModel.category) ?? .other,
                              name: dbModel.name,
                              timestamp: dbModel.timestamp)
    }
    
    func dbModel(from context: NSManagedObjectContext) -> DBFavouriteBoard {
        let dbModel = createModel(from: context)
        dbModel.identifier = identifier
        dbModel.category = category.rawValue
        dbModel.name = name
        dbModel.timestamp = timestamp
        
        return dbModel
    }
}
