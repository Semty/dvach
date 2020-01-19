//
//  LoginPresenter+ILoginValidatorOutput.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 25.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

// Interface for informing a presenter about validation state of all login forms
protocol ILoginValidatorOutput: AnyObject {
    func validationStateWasChanged(_ isValid: Bool)
    func needToUpdateEmailForm(email: String, contentType: UITextContentType)
    func getCurrentState() -> LoginPresenter.State
}

// MARK: - ILoginValidatorOutput

extension LoginPresenter: ILoginValidatorOutput {
    
    func validationStateWasChanged(_ isValid: Bool) {
        view?.updateCreateAccountButtonAvailability(isValid)
    }
    
    func getCurrentState() -> LoginPresenter.State {
        return state
    }
    
    func needToUpdateEmailForm(email: String, contentType: UITextContentType) {
        didChangeEmail(email, contentType)
        updateState(state)
        showPopUpView()
    }
}
