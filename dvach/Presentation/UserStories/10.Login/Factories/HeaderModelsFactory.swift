//
//  HeaderModelsFactory.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 20.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

protocol IHeaderModelsFactory {
    func getModel(with state: LoginPresenter.State) -> HeaderView.ConfigurationModel
}

final class HeaderModelsFactory: IHeaderModelsFactory {
    
    // MARK: - IHeaderModelsFactory
    
    func getModel(with state: LoginPresenter.State) -> HeaderView.ConfigurationModel {
        switch state {
        case .start, .signUp:
            return HeaderView.ConfigurationModel(title: "createAccountTitle",
                                                 subtitle: "subtitle",
                                                 animate: false)
        case .logOut:
            return HeaderView.ConfigurationModel(title: "logOutFromAccountTitle",
                                                 subtitle: "logOutSubtitle",
                                                 animate: false)
        case .logIn:
            return HeaderView.ConfigurationModel(title: "logInToAccountTitle",
                                                 subtitle: "subtitle",
                                                 animate: false)
        }
    }
}
