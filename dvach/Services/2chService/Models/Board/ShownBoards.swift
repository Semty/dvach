//
//  ShownBoard.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import CoreData

struct ShownBoard {
    var identifier: String
}

final class DBShownBoard: NSManagedObject {
    @NSManaged var identifier: String
}

// MARK: - Persistable

extension ShownBoard: Persistable {
    
    typealias DBModel = DBShownBoard

    static func from(_ dbModel: DBShownBoard) -> ShownBoard {
        return ShownBoard(identifier: dbModel.identifier)
    }
    
    func dbModel(from context: NSManagedObjectContext) -> DBShownBoard {
        let dbModel = createModel(from: context)
        dbModel.identifier = identifier
        
        return dbModel
    }
}
