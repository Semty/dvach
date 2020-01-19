//
//  LoginFormsFactory.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 18.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

protocol ILoginFormsFactory {
    func createForms()
    func getForms(with state: LoginPresenter.State) -> [LoginFormView]
    func getFirstInvalidOrActiveForm(with state: LoginPresenter.State) -> LoginFormView?
    func getEmailForm(with state: LoginPresenter.State) -> LoginFormView?
}

final class LoginFormsFactory {
    
    // Private Interface
    private var signUpForms = [LoginFormView]()
    private var logInForms = [LoginFormView]()
    
    // Delegate
    weak var output: ILoginFormsOutput?
}

// MARK: - ILoginFormsFactory

extension LoginFormsFactory: ILoginFormsFactory {
    
    func createForms() {
        let nameForm = createLoginNameForm()
        let emailForm = createLoginEmailForm()
        let passwordForm = createLoginPasswordForm()
        
        if signUpForms.isEmpty {
            signUpForms.append(nameForm)
            signUpForms.append(emailForm)
            signUpForms.append(passwordForm)
        }
        
        if logInForms.isEmpty {
            logInForms.append(emailForm)
            logInForms.append(passwordForm)
        }
    }
    
    func getForms(with state: LoginPresenter.State) -> [LoginFormView] {
        switch state {
        case .start, .logOut: return []
        case .logIn:
            logInForms.forEach {
                if #available(iOS 12.0, *) {
                    if $0.type == .newPassword {
                        $0.updatePasswordType(.password)
                    }
                }
            }
            return logInForms
        case .signUp:
            signUpForms.forEach {
                if #available(iOS 12.0, *) {
                    if $0.type == .password {
                        $0.updatePasswordType(.newPassword)
                    }
                }
            }
            return signUpForms
        }
    }
    
    func getFirstInvalidOrActiveForm(with state: LoginPresenter.State) -> LoginFormView? {
        switch state {
        case .start, .logOut: return nil
        case .logIn:
            for form in logInForms {
                if form.isFirstResponder &&
                    (form.validity == .invalid || form.validity == .hidden) {
                    return form
                }
            }
            for form in logInForms {
                if form.validity == .invalid || form.validity == .hidden {
                    return form
                }
            }
        case .signUp:
            for form in logInForms {
                if form.isFirstResponder &&
                    (form.validity == .invalid || form.validity == .hidden) {
                    return form
                }
            }
            for form in signUpForms {
                if form.validity == .invalid || form.validity == .hidden {
                    return form
                }
            }
        }
        return nil
    }
    
    func getEmailForm(with state: LoginPresenter.State) -> LoginFormView? {
        switch state {
        case .start, .logOut: return nil
        case .logIn:
            for form in logInForms {
                if form.type == .emailAddress {
                    return form
                }
            }
        case .signUp:
            for form in logInForms {
                if form.type == .emailAddress {
                    return form
                }
            }
        }
        return nil
    }
    
    // MARK: - Private
    
    private func createLoginNameForm() -> LoginFormView {
        let textfield = LoginTextField()
        let textFieldModel =
            LoginTextField.ConfigurationModel(text: nil, placeholder: .nameFormPlaceholder, contentType: .name, returnKeyType: .next, onTap: { [weak self] name, contentType in
                self?.output?.didTapName(name, contentType)
                }, onBegin: { [weak self] name, contentType in
                    self?.output?.didBeginName(name, contentType)
                }, onChange: { [weak self] name, contentType in
                    self?.output?.didChangeName(name, contentType)
                }, onEnd: { [weak self] name, contentType in
                    self?.output?.didEndName(name, contentType)
                }, onReturnKey: { [weak self] name, returnType, contentType in
                    self?.output?.didReturnName(name, returnType, contentType)
            })
        textfield.configure(with: textFieldModel)
        
        let validateView = LoginValidateView()
        let validateViewModel =
            LoginValidateView.ConfigurationModel(state: .hidden)
        validateView.configure(with: validateViewModel)
        
        let contentView = UIView()
        contentView.addSubview(textfield)
        contentView.addSubview(validateView)
        
        textfield.snp.makeConstraints { $0.centerY.leading.equalToSuperview() }
        validateView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(textfield.snp.trailing).offset(16)
        }
        
        let model = LoginFormView.ConfigurationModel(image: .nameFormIcon,
                                                     contentView: contentView)
        
        let loginNameView = LoginFormView.fromNib()
        loginNameView.configure(with: model)
        
        return loginNameView
    }
    
    private func createLoginEmailForm() -> LoginFormView {
        let textfield = LoginTextField()
        let textFieldModel =
            LoginTextField.ConfigurationModel(text: nil, placeholder: .emailFormPlaceholder, contentType: .emailAddress, returnKeyType: .next, onTap: { [weak self] email, contentType in
                self?.output?.didTapEmail(email, contentType)
                }, onBegin: { [weak self] email, contentType in
                    self?.output?.didBeginEmail(email, contentType)
                }, onChange: { [weak self] email, contentType in
                    self?.output?.didChangeEmail(email, contentType)
                }, onEnd: { [weak self] email, contentType in
                    self?.output?.didEndEmail(email, contentType)
                }, onReturnKey: { [weak self] email, returnType, contentType in
                    self?.output?.didReturnEmail(email, returnType, contentType)
            })
        textfield.configure(with: textFieldModel)
        
        let validateView = LoginValidateView()
        let validateViewModel =
            LoginValidateView.ConfigurationModel(state: .hidden)
        validateView.configure(with: validateViewModel)
        
        let contentView = UIView()
        contentView.addSubview(textfield)
        contentView.addSubview(validateView)
        
        textfield.snp.makeConstraints { $0.centerY.leading.equalToSuperview() }
        validateView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(textfield.snp.trailing).offset(16)
        }
        
        let model = LoginFormView.ConfigurationModel(image: .emailFormIcon,
                                                     contentView: contentView)
        
        let loginEmailView = LoginFormView.fromNib()
        loginEmailView.configure(with: model)
        
        return loginEmailView
    }
    
    private func createLoginPasswordForm() -> LoginFormView {
        let textfield = LoginTextField()
        let contentType: UITextContentType
        if #available(iOS 12.0, *) {
            contentType = .newPassword
        } else {
            contentType = .password
        }
        let textFieldModel =
            LoginTextField.ConfigurationModel(text: nil, placeholder: .passwordFormPlaceholder, contentType: contentType, returnKeyType: .done, onTap: { [weak self] password, contentType in
                self?.output?.didTapPassword(password, contentType)
                }, onBegin: { [weak self] password, contentType in
                    self?.output?.didBeginPassword(password, contentType)
                }, onChange: { [weak self] password, contentType in
                    self?.output?.didChangePassword(password, contentType)
                }, onEnd: { [weak self] password, contentType in
                    self?.output?.didEndPassword(password, contentType)
                }, onReturnKey: { [weak self] password, returnType, contentType in
                    self?.output?.didReturnPassword(password, returnType, contentType)
            })
        textfield.configure(with: textFieldModel)
        
        let validateView = LoginValidateView()
        let validateViewModel =
            LoginValidateView.ConfigurationModel(state: .hidden)
        validateView.configure(with: validateViewModel)
        
        let contentView = UIView()
        contentView.addSubview(textfield)
        contentView.addSubview(validateView)
        
        textfield.snp.makeConstraints { $0.centerY.leading.equalToSuperview() }
        validateView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(textfield.snp.trailing).offset(16)
        }
        
        let model = LoginFormView.ConfigurationModel(image: .passwordFormIcon,
                                                     contentView: contentView)
        
        let loginPassportView = LoginFormView.fromNib()
        loginPassportView.configure(with: model)
        
        return loginPassportView
    }
}

private extension UIImage {
    static let nameFormIcon = AppConstants.Images.Login.username
    static let emailFormIcon = AppConstants.Images.Login.email
    static let passwordFormIcon = AppConstants.Images.Login.password
}

private extension String {
    static let nameFormPlaceholder =
        AppConstants.Strings.Login.Forms.namePlaceholder
    static let emailFormPlaceholder =
        AppConstants.Strings.Login.Forms.emailPlaceholder
    static let passwordFormPlaceholder =
        AppConstants.Strings.Login.Forms.passwordPlaceholder
}
