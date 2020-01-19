//
//  GoToModelsFactory.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 20.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

protocol IGoToModelsFactory {
    func getModel(with state: LoginPresenter.State) -> LoginSignInSignUpView.ConfigurationModel
}

final class GoToModelsFactory {
    
    // Private Interface
    private let textAttributes = String.attributes(withFont: .font,
                                                   textAlignment: .center)
}

// MARK: - IGoToModelsFactory

extension GoToModelsFactory: IGoToModelsFactory {
    
    func getModel(with state: LoginPresenter.State) -> LoginSignInSignUpView.ConfigurationModel {
        let string: String
        let buttonString: String
        
        switch state {
        case .start, .signUp, .logOut:
            string = .toLogIn
            buttonString = .toLoginButton
        case .logIn:
            string = .toSignUp
            buttonString = .toSignUpButton
        }
        
        let font: UIFont = .font
        
        let text = string.withAttributes(textAttributes).mutableCopy() as! NSMutableAttributedString
        text.addAttribute(.font,
                          value: font,
                          range: (text.string as NSString).range(of: text.string))
        text.addAttribute(.foregroundColor,
                          value: Theme.current.mainColor,
                          range: (text.string as NSString).range(of: buttonString))
        
        let model = LoginSignInSignUpView.ConfigurationModel(text: text)
        
        return model
    }
}

// MARK: - Private Extensions

private extension UIFont {
    static let smallerFont = AppConstants.Font.regular(size: 14)
    static let font = AppConstants.Font.regular(size: 16)
}

private extension String {
    static let toLogIn = AppConstants.Strings.Login.AccountAvailability.toLogIn
    static let toSignUp = AppConstants.Strings.Login.AccountAvailability.toSignUp
    
    static let toLoginButton = AppConstants.Strings.Login.AccountAvailability.toLoginButton
    static let toSignUpButton = AppConstants.Strings.Login.AccountAvailability.toSignUpButton
}
