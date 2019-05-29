//
//  FireBaseService.swift
//  FatFood
//
//  Created by Kirill Solovyov on 27.07.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

protocol IFirebaseService {
    func observeRemoteDatabase(completion: @escaping ([String: Any], Error?) -> Void)
    func observeRemoteDatabase(for restarauntId: String, completion: @escaping ([String: Any], Error?) -> Void)
}

class FireBaseService: IFirebaseService {
    
    // Singleton
    public static let shared = FireBaseService()
    
    // Models
    private let databaseReference: DatabaseReference

    // MARK: - Initialization
    
    private init() {
        self.databaseReference = Database.database().reference()
    }
    
    // MARK: - IFirebaseService
    
    func observeRemoteDatabase(completion: @escaping ([String: Any], Error?) -> Void) {
        databaseReference.observeSingleEvent(of: DataEventType.value) { snapshot in
            if let result = snapshot.value as? [String: Any] {
                completion(result, nil)
            } else {
                completion([:], NSError.defaultError(description: "Can't observe remote database"))
            }
        }
    }
    
    func observeRemoteDatabase(for restarauntId: String,
                               completion: @escaping ([String: Any], Error?) -> Void) {
        databaseReference
            .child(restarauntId)
            .observeSingleEvent(of: DataEventType.value) { snapshot in
                if let result = snapshot.value as? [String: Any] {
                    completion(result, nil)
                } else {
                    completion([:], NSError.defaultError(description: "Can't observe remote database"))
                }
        }
    }
}
