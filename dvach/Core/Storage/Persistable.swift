//
//  Persistable.swift
//  FatFood
//
//  Created by Kirill Solovyov on 23.10.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import CoreData

protocol Persistable {
    
    associatedtype DBModel: NSManagedObject
    
    var identifier: String { get set }
    
    static func from(_ dbModel: DBModel) -> Self
    
    func dbModel(from context: NSManagedObjectContext) -> DBModel
    
    func createModel(from context: NSManagedObjectContext) -> DBModel
}

extension Persistable {
    
    static var entityName: String {
        return Self.DBModel.className
    }
    
    func createModel(from context: NSManagedObjectContext) -> DBModel {
        if let description = NSEntityDescription.entity(forEntityName: Self.entityName, in: context),
            let object = NSManagedObject(entity: description, insertInto: context) as? DBModel {
            
            return object
        } else {
            fatalError("Невозможно получить модель \(Self.entityName)")
        }
    }
}
