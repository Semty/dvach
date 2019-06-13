//
//  IStorage.swift
//  FatFood
//
//  Created by Kirill Solovyov on 03.11.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import CoreData

protocol IStorage {
    /// Стирает старые данные, заменяет новыми
    func replace<T: Persistable>(objects: [T])
    
    /// Сохраняет новые объекты, заменяет старые по identifier
    func save<T: Persistable>(objects: [T])
    func save<T: Persistable>(objects: [T], completion: @escaping () -> Void)
    
    func fetch<T: Persistable>(model: T.Type) -> [T]
    func fetch<T: Persistable>(model: T.Type,
                               predicate: NSPredicate?,
                               sortDescriptors: [NSSortDescriptor]) -> [T]
    
    func delete<T: Persistable>(model: T.Type, with identifier: String)
    func deleteAll<T: Persistable>(objects ofType: T.Type)
    
    func saveContext()
}
