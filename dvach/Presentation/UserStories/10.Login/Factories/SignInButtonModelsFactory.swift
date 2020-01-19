//
//  SignInButtonModelsFactory.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 24.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

protocol ISignInButtonModelsFactory {
    func getModel(with state: LoginPresenter.State) -> BottomButton.Model
}

final class SignInButtonModelsFactory: ISignInButtonModelsFactory {
    
    // MARK: - ISignInButtonModelsFactory
    
    func getModel(with state: LoginPresenter.State) -> BottomButton.Model {
        switch state {
        case .start, .logOut:
            return BottomButton.Model(text: "",
                                      image: nil,
                                      backgroundColor: .createAccountColor,
                                      textColor: .white)
        case .logIn:
            return BottomButton.Model(text: .logIn,
                                      image: nil,
                                      backgroundColor: .createAccountColor,
                                      textColor: .white)
        case .signUp:
            return BottomButton.Model(text: .signUp,
                                      image: nil,
                                      backgroundColor: .createAccountColor,
                                      textColor: .white)
        }
    }
}
