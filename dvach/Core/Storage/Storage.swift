//
//  Storage.swift
//  FatFood
//
//  Created by Kirill Solovyov on 23.10.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import CoreData

final class Storage: IStorage {
    
    // MARK: - IStorage
    func replace<T>(objects: [T]) where T: Persistable {
        deleteAll(objects: T.self)
        save(objects: objects)
    }
    
    func save<T>(objects: [T]) where T: Persistable {
        let request = NSFetchRequest<T.DBModel>(entityName: T.entityName)
        
        persistentContainer.performBackgroundTask { context in
            // При использовани констрейнтов в приоритете оставляет новые данные
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            objects.forEach { object in
                request.predicate = NSPredicate(format: "identifier == %@", object.identifier)
                let result = try? context.fetch(request)
                result?.forEach(context.delete)
                _ = object.dbModel(from: context)
            }
            
            try? context.save()
            print("DATA SAVED SUCCESSFULY")
        }
    }
    
    func fetch<T>(model: T.Type) -> [T] where T: Persistable {
        return fetch(model: model, predicate: nil, sortDescriptors: [])
    }
    
    func fetch<T>(model: T.Type,
                  predicate: NSPredicate?,
                  sortDescriptors: [NSSortDescriptor]) -> [T] where T: Persistable {
        let request = NSFetchRequest<T.DBModel>(entityName: T.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result.map(T.from)
        } catch {
            assert(true, "Can't fetch \(T.entityName)")
            fatalError()
        }
    }
    
    func delete<T>(model: T.Type, with identifier: String) where T: Persistable {
        let request = NSFetchRequest<T.DBModel>(entityName: T.entityName)
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            result.forEach(persistentContainer.viewContext.delete)
            saveContext()
        } catch {
            assert(true, "Can't delete \(T.entityName)")
            fatalError()
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAll<T: Persistable>(objects ofType: T.Type) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            assert(true, "Cant delete \(T.entityName)")
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "dvach")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
