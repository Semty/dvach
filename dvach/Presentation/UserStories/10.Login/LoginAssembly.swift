//
//  LoginAssembly.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 17.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

enum LoginAssembly {
    
    static func assemble(_ delegate: ILoginViewControllerDelegate? = nil) -> UIViewController {
        let signInButtonModelsFactory = SignInButtonModelsFactory()
        let popViewModelsFactory = PopViewModelsFactory()
        let headerModelsFactory = HeaderModelsFactory()
        let loginFormsFactory = LoginFormsFactory()
        let loginFormsValidator = LoginFormsValidator()
        let goToModelsFactory = GoToModelsFactory()
        let componentsFactory = Locator.shared.componentsFactory()
        let presenter =
            LoginPresenter(loginFormsFactory: loginFormsFactory,
                           loginFormsValidator: loginFormsValidator,
                           goToModelsFactory: goToModelsFactory,
                           headerModelsFactory: headerModelsFactory,
                           popViewModelsFactory: popViewModelsFactory,
                           signInButtonModelsFactory: signInButtonModelsFactory)
        if let _ = delegate {
            presenter.state = .start
        }
        let controller = LoginViewController(presenter: presenter,
                                             componentsFactory: componentsFactory)
        controller.delegate = delegate
        
        presenter.view = controller
        loginFormsFactory.output = presenter
        loginFormsValidator.output = presenter
        
        return controller
    }
}
