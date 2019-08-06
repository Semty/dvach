//
//  FireBaseService.swift
//  FatFood
//
//  Created by Kirill Solovyov on 27.07.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON

protocol IFirebaseService {
    
    /// Однократно делает запрос в firebase
    func observeRemoteDatabase(child: FireBaseService.Child,
                               completion: @escaping (JSON?, Error?) -> Void)
}

final class FireBaseService: IFirebaseService {
    
    public enum Child: String {
        case config
        case badWordsConfig
    }
    
    // Models
    private let databaseReference: DatabaseReference

    // MARK: - Initialization
    
    init() {
        self.databaseReference = Database.database().reference()
    }
    
    // MARK: - IFirebaseService
    
    func observeRemoteDatabase(child: Child, completion: @escaping (JSON?, Error?) -> Void) {
        databaseReference.child(child.rawValue).observeSingleEvent(of: DataEventType.value) { snapshot in
            if let result = snapshot.value as? [String: Any] {
                let json = JSON(result)
                completion(json, nil)
            } else {
                completion(nil, NSError.defaultError(description: "Can't observe remote database"))
            }
        }
    }
}
