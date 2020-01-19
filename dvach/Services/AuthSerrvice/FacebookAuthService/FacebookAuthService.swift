//
//  FacebookAuthService.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 21.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation
import FacebookLogin

protocol IFacebookAuthService: class {
    func startSignInWithFacebookFlow()
}

protocol IFacebookAuthOutput {
    func facebookAuthSuccessfull(with idToken: String)
    func facebookAuthFailed(with error: Error)
}

final class FacebookAuthService: IFacebookAuthService {
    
    // Delegate
    private let output: IFacebookAuthOutput?
    
    // MARK: - Initialization
    
    init(output: IFacebookAuthOutput) {
        self.output = output
    }
    
    deinit {
        print("FacebookAuthService deinit")
    }
    
    // MARK: - IFacebookAuthService
    
    func startSignInWithFacebookFlow() {
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.publicProfile, .email]
        ) { [weak self] result in
            self?.loginManagerDidComplete(result)
        }
    }
    
    // MARK: - Private
    
    private func loginManagerDidComplete(_ result: LoginResult) {
        switch result {
        case .cancelled:
//            let error = NSError(domain: "Авторизация отменена",
//                                code: -1,
//                                userInfo: nil)
//            output?.facebookAuthFailed(with: error as Error)
            break
        case .failed(let error):
            output?.facebookAuthFailed(with: error)
        case .success(_, _, let idToken):
            output?.facebookAuthSuccessfull(with: idToken.tokenString)
        }
    }
}
