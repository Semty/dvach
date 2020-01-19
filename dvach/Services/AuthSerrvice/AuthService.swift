//
//  AuthService.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 20.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation
import FirebaseAuth
import FacebookLogin

protocol IAuthService {
    var authServiceDelegate: IAuthServiceDelegate? { get set }
    func startSignInFlow(with authType: AuthService.AuthType,
                         authData: (name: String?, email: String, password: String)?)
    func startSignOutFlow()
    func startPasswordResetFlow(_ email: String)
}

extension IAuthService {
    func startSignInFlow(with authType: AuthService.AuthType) {
        startSignInFlow(with: authType, authData: nil)
    }
}

protocol IAuthServiceDelegate: class {
    func authSuccessfull(with authResult: AuthDataResult,
                         authType: AuthService.AuthType)
    func authFailed(with error: Error)
    
    func deauthSuccessfull()
    func deauthFailed(with error: Error)
    
    func passwordResetSuccessfull()
    func passwordResetFailed(with error: Error)
    
    func firebaseWillStartFetchingUserData()
    func firebaseDidEndFetchingUserData()
}

final class AuthService: IAuthService {
    
    enum AuthType {
        case emailSignUp
        case emailLogIn
        
        case facebook
        
        @available(iOS 13.0, *)
        case apple
    }
    
    // Delegate
    public weak var authServiceDelegate: IAuthServiceDelegate?
    
    // Services
    private var _appleAuthService: NSObjectProtocol? = nil
    @available(iOS 13.0, *)
    fileprivate var appleAuthService: IAppleAuthService {
        if _appleAuthService == nil {
            print("\nNEW APPLE AUTH SERVICE CREATED\n")
            _appleAuthService = AppleAuthService(output: self)
        }
        return _appleAuthService as! IAppleAuthService
    }
    
    private var facebookAuthService: IFacebookAuthService?
    
    // MARK: - Initialization
    
    init() {}
    
    deinit {
        print("AuthService deinit")
    }
    
    // MARK: - IAuthService
    
    func startSignInFlow(with authType: AuthService.AuthType,
                         authData: (name: String?, email: String, password: String)?) {
        switch authType {
        case .emailSignUp:
            if let authData = validAuthData(authData) {
                startSignUpWithFirebaseEmailBasedFlow(with: authData.name,
                                                      authData.email,
                                                      authData.password)
            }
        case .emailLogIn:
            if let authData = validAuthData(authData) {
                startLogInWithFirebaseEmailBasedFlow(with: authData.email,
                                                     authData.password)
            }
        case .facebook:
            startSignInWithFacebookFlow()
        case .apple:
            if #available(iOS 13.0, *) {
                startSignInWithAppleFlow()
            }
        }
    }
    
    func startSignOutFlow() {
        do {
            authServiceDelegate?.firebaseWillStartFetchingUserData()
            try Auth.auth().signOut()
            authServiceDelegate?.firebaseDidEndFetchingUserData()
            postNotificationAuthDidUpdate()
            authServiceDelegate?.deauthSuccessfull()
        } catch let error {
            authServiceDelegate?.firebaseDidEndFetchingUserData()
            authServiceDelegate?.deauthFailed(with: error)
        }
    }
    
    func startPasswordResetFlow(_ email: String) {
        authServiceDelegate?.firebaseWillStartFetchingUserData()
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            self?.authServiceDelegate?.firebaseDidEndFetchingUserData()
            if let error = error {
                self?.authServiceDelegate?.passwordResetFailed(with: error)
            } else {
                self?.authServiceDelegate?.passwordResetSuccessfull()
            }
        }
    }
    
    // MARK: - Private
    
    private func validAuthData(_ authData: (name: String?, email: String, password: String)?) -> (name: String?, email: String, password: String)? {
        if let authData = authData {
            return authData
        } else {
            let error = NSError(domain: "Данные авторизации не получены",
                                code: -1,
                                userInfo: nil)
            authServiceDelegate?.authFailed(with: error as Error)
            return nil
        }
    }
    
    // MARK: - Notifications
    
    private func postNotificationAuthDidUpdate() {
        NotificationCenter.default.post(name: Notifications.authStateDidUpdate.name, object: nil)
    }
}

// MARK: - Start Sign In Flow With Facebook and Apple

extension AuthService {
    
    @available(iOS 13.0, *)
    private func startSignInWithAppleFlow() {
        appleAuthService.startSignInWithAppleFlow()
    }
    
    private func startSignInWithFacebookFlow() {
        facebookAuthService = FacebookAuthService(output: self)
        facebookAuthService?.startSignInWithFacebookFlow()
    }
}

// MARK: - Start Sign In Flow With Firebase email based SignUp and LogIn

extension AuthService {
    
    private func startSignUpWithFirebaseEmailBasedFlow(with name: String?,
                                                       _ email: String,
                                                       _ password: String) {
        authServiceDelegate?.firebaseWillStartFetchingUserData()
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.handleAuthResponse(with: authResult, error, .emailSignUp)
            } else {
                if let user = Auth.auth().currentUser {
                    let request = user.createProfileChangeRequest()
                    request.displayName = name
                    request.commitChanges { [weak self] error in
                        self?.handleAuthResponse(with: authResult, error, .emailSignUp)
                    }
                } else {
                    let error = NSError(domain: "Данные пользователя не найдены",
                                        code: -1,
                                        userInfo: nil)
                    DispatchQueue.main.async { [weak self] in
                        self?.authServiceDelegate?.authFailed(with: error as Error)
                    }
                }
            }
        }
    }
    
    private func startLogInWithFirebaseEmailBasedFlow(with email: String,
                                                      _ password: String) {
        authServiceDelegate?.firebaseWillStartFetchingUserData()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            self?.handleAuthResponse(with: authResult,
                                     error,
                                     .emailLogIn)
        }
    }
}

// MARK: - Firebase Sign In Flow With Credential

extension AuthService {
    
    private func signIn(with credential: AuthCredential, authType: AuthType) {
        authServiceDelegate?.firebaseWillStartFetchingUserData()
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            self?.handleAuthResponse(with: authResult,
                                     error,
                                     authType)
        }
    }
}

// MARK: - Handle Auth Response

extension AuthService {
    
    private func handleAuthResponse(with authResult: AuthDataResult?,
                                    _ error: Error?, _ authType: AuthType) {
        authServiceDelegate?.firebaseDidEndFetchingUserData()
        if let error = error {
            DispatchQueue.main.async { [weak self] in
                self?.authServiceDelegate?.authFailed(with: error)
            }
        } else {
            if let authResult = authResult {
                DispatchQueue.main.async { [weak self] in
                    self?.postNotificationAuthDidUpdate()
                    self?.authServiceDelegate?.authSuccessfull(with: authResult,
                                                               authType: authType)
                }
            } else {
                let error = NSError(
                    domain: "Авторизация прошла успешна, но информация по пути где-то потерялась, попробуйте позже",
                    code: -1,
                    userInfo: nil
                )
                DispatchQueue.main.async { [weak self] in
                    self?.authServiceDelegate?.authFailed(with: error as Error)
                }
            }
        }
    }
}

// MARK: - IFacebookAuthOutput

extension AuthService: IFacebookAuthOutput {
    
    func facebookAuthSuccessfull(with idToken: String) {
        facebookAuthService = nil
        let credential =
            FacebookAuthProvider.credential(withAccessToken: idToken)
        signIn(with: credential, authType: .facebook)
    }
    
    func facebookAuthFailed(with error: Error) {
        facebookAuthService = nil
        authServiceDelegate?.authFailed(with: error)
    }
}

// MARK: - IAppleAuthService

@available(iOS 13.0, *)
extension AuthService: IAppleAuthOutput {

    func appleAuthSuccessfull(with idToken: String, rawNonce: String) {
        _appleAuthService = nil
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idToken,
                                                  rawNonce: rawNonce)
        signIn(with: credential, authType: .apple)
    }

    func appleAuthFailed(with error: Error) {
        _appleAuthService = nil
        authServiceDelegate?.authFailed(with: error)
    }
}
