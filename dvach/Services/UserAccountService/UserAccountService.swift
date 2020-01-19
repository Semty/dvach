//
//  UserAccountService.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 25.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol IUserAccountService {
    var name: String? { get }
    var email: String? { get }
    var isUserSignIn: Bool { get }
}

final class UserAccountService: IUserAccountService {
    
    // Public Interface
    public var name: String? {
        if isUserSignIn {
            return currentUser?.displayName ?? email
        } else {
            return nil
        }
    }
    
    public var email: String? {
        return currentUser?.email
    }
    
    public var isUserSignIn: Bool {
        if let _ = currentUser {
            return true
        } else {
            return false
        }
    }
    
    // Private Interface
    private var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    // MARK: - IUserAccountService
}
