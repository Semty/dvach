//
//  LoginPresenter+IAuthServiceDelegate.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 25.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation
import FirebaseAuth

// MARK: - IAuthServiceDelegate

extension LoginPresenter: IAuthServiceDelegate {
    
    func authSuccessfull(with authResult: AuthDataResult,
                         authType: AuthService.AuthType) {
        if view?.keyboardIsShown ?? false {
            view?.forceLoginFormResignFirstResponder()
        }
        view?.showSuccessAlertAndCloseViewController(with: "Ура!")
    }
    
    func authFailed(with error: Error) {
        let error = error as NSError
        if error.code == .emailAlreadyInUseErrorCode {
            loginFormsValidator.currentEmailHasProvenToBeInUse()
        }
        view?.showErrorAlert(with: error.localizedDescription)
    }
    
    func deauthSuccessfull() {
        view?.showSuccessAlert(with: "success")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.updateState(.signUp)
        }
    }
    
    func deauthFailed(with error: Error) {
        let error = error as NSError
        view?.showErrorAlert(with: error.localizedDescription)
    }
    
    func passwordResetSuccessfull() {
        view?.showSuccessAlert(with: "passwordReset")
    }
    
    func passwordResetFailed(with error: Error) {
        let error = error as NSError
        view?.showErrorAlert(with: error.localizedDescription)
    }
    
    func firebaseWillStartFetchingUserData() {
        view?.showLoaderAlert()
    }
    
    func firebaseDidEndFetchingUserData() {
        view?.dismissLoaderAlert()
    }
}

// MARK: - Private Extensions

private extension Int {
    static let emailAlreadyInUseErrorCode = 17007
}
