//
//  LoginPresenter+ILoginFormsOutput.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 25.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

// Interface for informing a presenter about events of login forms
protocol ILoginFormsOutput: AnyObject {
    func didTapName(_ name: String, _ contentType: UITextContentType)
    func didTapEmail(_ email: String, _ contentType: UITextContentType)
    func didTapPassword(_ password: String, _ contentType: UITextContentType)
    
    func didBeginName(_ name: String, _ contentType: UITextContentType)
    func didBeginEmail(_ email: String, _ contentType: UITextContentType)
    func didBeginPassword(_ password: String, _ contentType: UITextContentType)
    
    func didChangeName(_ name: String, _ contentType: UITextContentType)
    func didChangeEmail(_ email: String, _ contentType: UITextContentType)
    func didChangePassword(_ password: String, _ contentType: UITextContentType)
    
    func didReturnName(_ name: String, _ returnType: UIReturnKeyType, _ contentType: UITextContentType)
    func didReturnEmail(_ email: String, _ returnType: UIReturnKeyType, _ contentType: UITextContentType)
    func didReturnPassword(_ password: String, _ returnType: UIReturnKeyType, _ contentType: UITextContentType)
    
    func didEndName(_ name: String, _ contentType: UITextContentType)
    func didEndEmail(_ email: String, _ contentType: UITextContentType)
    func didEndPassword(_ password: String, _ contentType: UITextContentType)
}

// MARK: - ILoginFormsOutput

extension LoginPresenter: ILoginFormsOutput {
    
    // MARK: - Did Tap
    
    func didTapName(_ name: String, _ contentType: UITextContentType) {
        hidePopViewIfNeeded()
    }
    
    func didTapEmail(_ email: String, _ contentType: UITextContentType) {
        hidePopViewIfNeeded()
    }
    
    func didTapPassword(_ password: String, _ contentType: UITextContentType) {
        hidePopViewIfNeeded()
    }
    
    // MARK: - Did Begin
    
    func didBeginName(_ name: String, _ contentType: UITextContentType) {
        view?.update(contentType)
        hidePopViewIfNeeded()
    }
    
    func didBeginEmail(_ email: String, _ contentType: UITextContentType) {
        view?.update(contentType)
        hidePopViewIfNeeded()
    }
    
    func didBeginPassword(_ password: String, _ contentType: UITextContentType) {
        view?.update(contentType)
        hidePopViewIfNeeded()
    }
    
    // MARK: - Did Change
    
    func didChangeName(_ name: String, _ contentType: UITextContentType) {
        if let validation = loginFormsValidator.validate(name, contentType) {
            view?.update(contentType, with: validation)
        }
        hidePopViewIfNeeded()
    }
    
    func didChangeEmail(_ email: String, _ contentType: UITextContentType) {
        if let validation = loginFormsValidator.validate(email, contentType) {
            view?.update(contentType, with: validation)
        }
        hidePopViewIfNeeded()
    }
    
    func didChangePassword(_ password: String, _ contentType: UITextContentType) {
        if let validation = loginFormsValidator.validate(password, contentType) {
            view?.update(contentType, with: validation)
        }
        hidePopViewIfNeeded()
    }
    
    // MARK: - Did Return
    
    func didReturnName(_ name: String, _ returnType: UIReturnKeyType, _ contentType: UITextContentType) {
        if !loginFormsValidator.nameOnceValidated {
            if let validation = loginFormsValidator.validate(name, contentType, force: true) {
                view?.update(contentType, with: validation)
            }
        }
        view?.makeNextLoginFormFirstResponder()
        hidePopViewIfNeeded()
    }
    
    func didReturnEmail(_ email: String, _ returnType: UIReturnKeyType, _ contentType: UITextContentType) {
        if !loginFormsValidator.emailOnceValidated {
            if let validation = loginFormsValidator.validate(email, contentType, force: true) {
                view?.update(contentType, with: validation)
            }
        }
        view?.makeNextLoginFormFirstResponder()
        hidePopViewIfNeeded()
    }
    
    func didReturnPassword(_ password: String, _ returnType: UIReturnKeyType, _ contentType: UITextContentType) {
        if !loginFormsValidator.passwordOnceValidated {
            if let validation = loginFormsValidator.validate(password, contentType, force: true) {
                view?.update(contentType, with: validation)
            }
        }
        hidePopViewIfNeeded()
        view?.makeNextLoginFormFirstResponder()
    }
    
    // MARK: - Did End
    
    func didEndName(_ name: String, _ contentType: UITextContentType) {
        view?.update(contentType)
        if !loginFormsValidator.nameOnceValidated {
            if let validation = loginFormsValidator.validate(name, contentType, force: true) {
                view?.update(contentType, with: validation)
            }
        }
    }
    
    func didEndEmail(_ email: String, _ contentType: UITextContentType) {
        view?.update(contentType)
        if !loginFormsValidator.emailOnceValidated {
            if let validation = loginFormsValidator.validate(email, contentType, force: true) {
                view?.update(contentType, with: validation)
            }
        }
    }
    
    func didEndPassword(_ password: String, _ contentType: UITextContentType) {
        view?.update(contentType)
        if !loginFormsValidator.passwordOnceValidated {
            if let validation = loginFormsValidator.validate(password, contentType, force: true) {
                view?.update(contentType, with: validation)
            }
        }
    }
    
    // MARK: - Private
    
    private func hidePopViewIfNeeded() {
        if view?.isPopViewPrersented ?? false {
            view?.dismissPopUp()
        }
    }
}
