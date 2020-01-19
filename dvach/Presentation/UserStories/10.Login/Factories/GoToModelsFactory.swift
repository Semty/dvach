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
    private let textAttributes = String.attributes(withFont: UIFont(), textAlignment: .center)
}

// MARK: - IGoToModelsFactory

extension GoToModelsFactory: IGoToModelsFactory {
    
    func getModel(with state: LoginPresenter.State) -> LoginSignInSignUpView.ConfigurationModel {
        let string: String
        let buttonString: String
        
        switch state {
        case .start, .signUp, .logOut:
            string = "toLogIn"
            buttonString = "toLoginButton"
        case .logIn:
            string = "toSignUp"
            buttonString = "toSignUpButton"
        }
        
        let font: UIFont = UIFont.systemWith(size: .size18) ?? UIFont()
        
        let text = string.withAttributes(textAttributes).mutableCopy() as! NSMutableAttributedString
        text.addAttribute(.font,
                          value: font,
                          range: (text.string as NSString).range(of: text.string))
        text.addAttribute(.foregroundColor,
                          value: UIColor.white,
                          range: (text.string as NSString).range(of: buttonString))
        
        let model = LoginSignInSignUpView.ConfigurationModel(text: text)
        
        return model
    }
}
