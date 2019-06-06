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
    
    /// Однократно делает запрос в firebase
    func observeRemoteDatabase(completion: @escaping (JSON?, Error?) -> Void)
}

final class FireBaseService: IFirebaseService {
    
    // Models
    private let databaseReference: DatabaseReference

    // MARK: - Initialization
    
    init() {
        self.databaseReference = Database.database().reference()
    }
    
    // MARK: - IFirebaseService
    
    func observeRemoteDatabase(completion: @escaping (JSON?, Error?) -> Void) {
        databaseReference.observeSingleEvent(of: DataEventType.value) { snapshot in
            if let result = snapshot.value as? [String: Any] {
                let json = JSON(result)
                completion(json, nil)
            } else {
                completion(nil, NSError.defaultError(description: "Can't observe remote database"))
            }
        }
    }
}
