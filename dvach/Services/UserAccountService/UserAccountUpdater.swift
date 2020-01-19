//
//  UserAccountUpdater.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 25.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

protocol IUserAccountUpdater {
    func addDelegate(_ delegate: UserAccountUpdaterDelegate)
}

protocol UserAccountUpdaterDelegate: AnyObject {
    func userAccountDidUpdateData()
}

enum Notifications: String, NotificationName {
    case authStateDidUpdate
}

final class UserAccountUpdater: IUserAccountUpdater {
    
    static let shared = UserAccountUpdater()
    
    private init() {
        subscribe()
    }
    
    private let delegates = DelegateList<UserAccountUpdaterDelegate>()
    
    // MARK: - IUserAccountUpdater
    
    func addDelegate(_ delegate: UserAccountUpdaterDelegate) {
        delegates.addDelegate(delegate)
    }
    
    // MARK: - Private
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchAuthChanges),
                                               name: Notifications.authStateDidUpdate.name,
                                               object: nil)
    }
    
    // MARK: - Actions
    
    @objc private func fetchAuthChanges() {
        DispatchQueue.main.async {
            self.delegates.forEach { $0.userAccountDidUpdateData() }
        }
    }
}
