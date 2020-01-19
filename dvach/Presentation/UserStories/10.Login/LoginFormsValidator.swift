//
//  LoginFormsValidator.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 19.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

protocol ILoginFormsValidator {
    var userData: (name: String?, email: String, password: String) { get }
    var inProcessOfLogin: Bool { get }
    var nameOnceValidated: Bool { get }
    var emailOnceValidated: Bool { get }
    var forgotPasswordFormValidity: Bool { get }
    var passwordOnceValidated: Bool { get }
    
    func validate(_ text: String, _ type: UITextContentType, force: Bool) -> LoginFormView.State?
    func currentEmailHasProvenToBeInUse()
}

extension ILoginFormsValidator {
    func validate(_ text: String, _ type: UITextContentType, force: Bool = false) -> LoginFormView.State? {
        validate(text, type, force: force)
    }
}

final class LoginFormsValidator {
    
    // Delegate
    weak var output: ILoginValidatorOutput?
    
    // Private Interface
    private var isNameValid = false
    private var isEmailValid = false
    private var isPasswordValid = false
    private var emailsAlreadyInUse = Set<String>()
    
    private var name = ""
    private var password = ""
    private var email = ""
    
    private var isAllValid = false
    
    // ILoginFormsValidator
    private(set) var nameOnceValidated = false
    private(set) var emailOnceValidated = false
    private(set) var passwordOnceValidated = false
    
    public var inProcessOfLogin: Bool {
        guard let state = output?.getCurrentState() else { return false }
        switch state {
        case .logIn:
            return isEmailValid && isPasswordValid
        case .signUp:
            return isNameValid && isEmailValid && isPasswordValid
        case .start, .logOut:
            return false
        }
    }
    
    public var forgotPasswordFormValidity: Bool {
        return isEmailValid
    }
    
    public var userData: (name: String?, email: String, password: String) {
        return (name: name.isEmpty ? nil : name, email: email, password: password)
    }
}

// MARK: - ILoginFormsValidator

extension LoginFormsValidator: ILoginFormsValidator {
    
    func validate(_ text: String, _ type: UITextContentType, force: Bool = false) -> LoginFormView.State? {
        
        if #available(iOS 12.0, *) {
            if type == .newPassword || type == .password {
                return passwordValidate(text, type, force: force)
            }
        } else {
            if type == .password {
                return passwordValidate(text, type, force: force)
            }
        }
        
        switch type {
        case .name:
            name = text
            isNameValid = text.isNameValid()
            checkAllFormsValidationState()
            if nameOnceValidated || isNameValid || force {
                nameOnceValidated = true
                return isNameValid ? .valid : .invalid
            }
        case .emailAddress:
            let text = text.trimmingCharacters(in: .whitespaces)
            email = text
            isEmailValid = text.isEmailValid()
            if emailsAlreadyInUse.contains(text) {
                isEmailValid = false
            }
            checkAllFormsValidationState()
            if emailOnceValidated || isEmailValid || force {
                emailOnceValidated = true
                return isEmailValid ? .valid : .invalid
            }
        default: break
        }
        
        return nil
    }
    
    func currentEmailHasProvenToBeInUse() {
        emailsAlreadyInUse.insert(email)
        output?.needToUpdateEmailForm(email: email, contentType: .emailAddress)
    }
}

// MARK: - Private

extension LoginFormsValidator {
    
    private func passwordValidate(_ text: String, _ type: UITextContentType, force: Bool = false) -> LoginFormView.State? {
        let text = text.trimmingCharacters(in: .whitespaces)
        password = text
        isPasswordValid = text.count >= 6
        checkAllFormsValidationState()
        if passwordOnceValidated || isPasswordValid || force {
            passwordOnceValidated = true
            return isPasswordValid ? .valid : .invalid
        }
        return nil
    }
    
    private func checkAllFormsValidationState() {
        
        guard let state = output?.getCurrentState() else { return }
        
        let newValidationState: Bool
        
        switch state {
        case .logIn:
            newValidationState = isEmailValid && isPasswordValid
        case .signUp:
            newValidationState = isNameValid && isEmailValid && isPasswordValid
        case .start, .logOut:
            return
        }
        
        if isAllValid != newValidationState {
            isAllValid = newValidationState
            output?.validationStateWasChanged(newValidationState)
        }
    }
}
