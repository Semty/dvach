//
//  LoginPresenter.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 17.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

// Interface for informing a presenter about events of root view
protocol ILoginPresenter {
    func viewDidLoad()
    func toLoginButtonTapped()
    func toSignUpButtonTapped()
    func appleButtonTapped()
    func facebookButtonTapped()
    func emailButtonTapped()
    func signInButtonTapped()
    func forgotPasswordButtonTapped()
    func signOutButtonTapped()
    func closeButtonTapped()
    func keyboardWillAppear()
    func keyboardWillDisappear()
}

final class LoginPresenter {

    enum State {
        case start
        
        case logIn
        case signUp
        
        case logOut
    }
    
    // Default State
    internal var state: State = .signUp
    
    // Dependencies
    weak var view: ILoginView?
    
    internal let loginFormsValidator: ILoginFormsValidator
    
    private let loginFormsFactory: ILoginFormsFactory
    private let goToModelsFactory: IGoToModelsFactory
    private let headerModelsFactory: IHeaderModelsFactory
    private let signInButtonModelsFactory: ISignInButtonModelsFactory
    private let popViewModelsFactory: IPopViewModelsFactory
    
    private lazy var authService: IAuthService = {
        var service = Locator.shared.authService()
        service.authServiceDelegate = self
        return service
    }()
    private lazy var accountService = Locator.shared.accountService()
    
    // MARK: - Initialize
    
    init(loginFormsFactory: ILoginFormsFactory,
         loginFormsValidator: ILoginFormsValidator,
         goToModelsFactory: IGoToModelsFactory,
         headerModelsFactory: IHeaderModelsFactory,
         popViewModelsFactory: IPopViewModelsFactory,
         signInButtonModelsFactory: ISignInButtonModelsFactory) {
        self.loginFormsFactory = loginFormsFactory
        self.loginFormsValidator = loginFormsValidator
        self.goToModelsFactory = goToModelsFactory
        self.headerModelsFactory = headerModelsFactory
        self.popViewModelsFactory = popViewModelsFactory
        self.signInButtonModelsFactory = signInButtonModelsFactory
        
        loginFormsFactory.createForms()
        
        if accountService.isUserSignIn {
            state = .logOut
        } else {
            state = .signUp
        }
    }
    
    // MARK: - Private
    
    internal func updateState(_ state: State) {
        let loginForms = loginFormsFactory.getForms(with: state)
        let goToModel = goToModelsFactory.getModel(with: state)
        let headerModel = headerModelsFactory.getModel(with: state)
        let signInButtonModel = signInButtonModelsFactory.getModel(with: state)
        
        view?.setup(loginForms: loginForms,
                    goToModel: goToModel,
                    headerModel: headerModel,
                    signInButtonModel: signInButtonModel,
                    inProcessOfLogin: loginFormsValidator.inProcessOfLogin,
                    state: state)
        
        if self.state == .start && state != .start {
            view?.forceLoginFormBecomeFirstResponder()
        }
        
        self.state = state
    }
    
    internal func showPopUpView(forceEmail: Bool? = nil) {
        if let isPopViewPresented = view?.isPopViewPrersented, !isPopViewPresented {
            let form: LoginFormView?
            if let forceEmail = forceEmail, forceEmail {
                form = loginFormsFactory.getEmailForm(with: state)
            } else {
                form = loginFormsFactory.getFirstInvalidOrActiveForm(with: state)
            }
            guard let invalidForm = form else { return }
            guard let invalidType = invalidForm.type else { return }
            guard let popViewModel = popViewModelsFactory.getModel(with: invalidType) else { return }
            view?.showPopUp(from: invalidForm,
                            with: popViewModel)
        }
    }
}

// MARK: - ILoginPresenter

extension LoginPresenter: ILoginPresenter {
    
    func viewDidLoad() {
        updateState(state)
    }
    
    func toLoginButtonTapped() {
        updateState(.logIn)
    }
    
    func toSignUpButtonTapped() {
        updateState(.signUp)
    }
    
    func appleButtonTapped() {
        if #available(iOS 13.0, *) {
            authService.startSignInFlow(with: .apple)
        } else {
            // TODO: - Add handler for iOS < 13.0 (but it's really )
        }
    }
    
    func facebookButtonTapped() {
        authService.startSignInFlow(with: .facebook)
    }
    
    func emailButtonTapped() {
        updateState(.signUp)
    }
    
    func signInButtonTapped() {
        if loginFormsValidator.inProcessOfLogin {
            let userData = loginFormsValidator.userData
            switch state {
            case .logIn:
                authService.startSignInFlow(with: .emailLogIn,
                                            authData: userData)
            case .signUp:
                authService.startSignInFlow(with: .emailSignUp,
                                            authData: userData)
            default:
                break
            }
        } else {
            showPopUpView()
        }
    }
    
    func forgotPasswordButtonTapped() {
        if loginFormsValidator.forgotPasswordFormValidity {
            let email = loginFormsValidator.userData.email
            authService.startPasswordResetFlow(email)
        } else {
            showPopUpView(forceEmail: true)
        }
    }
    
    func signOutButtonTapped() {
        if accountService.isUserSignIn {
            authService.startSignOutFlow()
        } else {
            updateState(.signUp)
        }
    }
    
    func closeButtonTapped() {
        if view?.keyboardIsShown ?? false {
            view?.forceLoginFormResignFirstResponder()
        } else {
            view?.closeViewController()
        }
    }
    
    func keyboardWillAppear() {
        view?.adjustUIForKeyboardAppearance(inProcessOfLogin: loginFormsValidator.inProcessOfLogin)
    }
    
    func keyboardWillDisappear() {
        view?.adjustUIForKeyboardDisappearance(inProcessOfLogin: loginFormsValidator.inProcessOfLogin, completion: nil)
    }
}
