//
//  LoginViewController+ILoginView.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 25.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation
import IHProgressHUD

protocol ILoginView: AnyObject {
    var keyboardIsShown: Bool { get }
    var isPopViewPrersented: Bool { get }
    
    func setup(loginForms: [LoginFormView],
               goToModel: LoginSignInSignUpView.ConfigurationModel,
               headerModel: HeaderView.ConfigurationModel,
               signInButtonModel: BottomButton.Model,
               inProcessOfLogin: Bool,
               state: LoginPresenter.State)
    func update(_ loginFormType: UITextContentType,
    with state: LoginFormView.State)
    func update(_ loginFormType: UITextContentType)
    
    func forceLoginFormBecomeFirstResponder()
    func forceLoginFormResignFirstResponder()
    func makeNextLoginFormFirstResponder()
    
    func updateCreateAccountButtonAvailability(_ isEnabled: Bool)
    
    func adjustUIForKeyboardAppearance(inProcessOfLogin: Bool)
    func adjustUIForKeyboardDisappearance(inProcessOfLogin: Bool,
                                          completion: (() -> Void)?)
    
    func closeViewController()
    
    func showSuccessAlert(with text: String)
    func showSuccessAlertAndCloseViewController(with text: String)
    func showErrorAlert(with text: String)
    func showLoaderAlert()
    func dismissLoaderAlert()
    
    func showPopUp(from view: UIView, with model: PopViewModelsFactory.Model)
    func dismissPopUp()
}

// MARK: - ILoginView

extension LoginViewController: ILoginView {
    
    func setup(loginForms: [LoginFormView],
               goToModel: LoginSignInSignUpView.ConfigurationModel,
               headerModel: HeaderView.ConfigurationModel,
               signInButtonModel: BottomButton.Model,
               inProcessOfLogin: Bool,
               state: LoginPresenter.State) {
        
        signInButton.configure(with: signInButtonModel)
        forgotPasswordView.alpha = 0.0
        if state != .logIn {
            signInButton.snp.updateConstraints {
                $0.top.equalTo(forgotPasswordView.snp.bottom).offset(-10)
            }
            forgotPasswordView.isHidden = true
        } else {
            signInButton.snp.updateConstraints {
                $0.top.equalTo(forgotPasswordView.snp.bottom).offset(18)
            }
            forgotPasswordView.isHidden = false
        }
        UIView.animate(withDuration: .animationDuration, animations: { [weak self] in
            guard let self = self else { return }
            let loginFormsState: LoginFormsView.State
            
            if state == .logOut {
                self.facebookAppleStackView.alpha = 0.0
                self.orView.alpha = 0.0
                self.goToView.alpha = 0.0
                self.signOutButton.alpha = 1.0
            } else {
                self.facebookAppleStackView.alpha = 1.0
                self.orView.alpha = 1.0
                self.goToView.alpha = 1.0
                self.signOutButton.alpha = 0.0
            }
            
            switch state {
            case .logOut:
                loginFormsState = .hidden
                self.emailButton.alpha = 0.0
            case .start:
                loginFormsState = .hidden
                self.emailButton.alpha = 1.0
            case .logIn:
                loginFormsState = .logIn
                self.emailButton.alpha = 0.0
            case .signUp:
                loginFormsState = .signUp
                self.emailButton.alpha = 0.0
                if !self.keyboardIsShown && !inProcessOfLogin {
                    self.signInButton.alpha = 0.0
                }
            }
            
            let model = LoginFormsView.ConfigurationModel(state: loginFormsState,
                                                          forms: loginForms)
            self.loginFormsContainer.configure(with: model, completion: { [weak self] in
                if state == .logIn {
                    UIView.animate(withDuration: .animationDuration / 2) {
                        self?.forgotPasswordView.alpha = 1.0
                    }
                }
            })
            self.goToView.configure(with: goToModel)
            self.headerView.configure(with: headerModel)
            self.signInButton.layoutIfNeeded()
            }, completion: nil /*{  [weak self] _ in
                if UIscreen.main.currentIPhone == .iPhone5 {
                    self?.fixSomeUIOnIphone5(with: state)
                }
        }*/)
    }
    
    func forceLoginFormBecomeFirstResponder() {
        if !loginFormsContainer.isThereFirstResponder() {
            loginFormsContainer.forceLoginFormFirstResponder()
        }
    }
    
    func forceLoginFormResignFirstResponder() {
        view.endEditing(true)
    }
    
    func makeNextLoginFormFirstResponder() {
        loginFormsContainer.makeNextLoginFormFirstResponder()
    }
    
    func update(_ loginFormType: UITextContentType,
                with state: LoginFormView.State) {
        loginFormsContainer.updateValidation(loginFormType,
                                             with: state)
    }
    
    func update(_ loginFormType: UITextContentType) {
        loginFormsContainer.update(loginFormType)
    }
    
    func updateCreateAccountButtonAvailability(_ isEnabled: Bool) {
        signInButton.isEnabled = isEnabled
    }
    
    func adjustUIForKeyboardAppearance(inProcessOfLogin: Bool) {
        // Temporarily disabled
//        closeButton.isHidden = true
//        closeButton.alpha = 0.0
        UIView.animateKeyframes(withDuration: .animationDuration, delay: 0, options: [.calculationModeLinear, .beginFromCurrentState], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 5/10) { [weak self] in
                guard let self = self else { return }
                self.headerView.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(-self.headerView.bounds.height)
                }
                self.loginFormsContainer.snp.updateConstraints {
                    if let newTopOffset = self.calculateLoginFormsTopOffsetDuringKeyboardApperance() {
                        $0.top.lessThanOrEqualTo(self.headerView.snp.bottom).offset(newTopOffset)
                    } else {
                        $0.top.lessThanOrEqualTo(self.headerView.snp.bottom).offset(self.headerView.bounds.height/2)
                    }
                }
                self.view.layoutIfNeeded()
            }
            // Temporarily disabled
//            UIView.addKeyframe(withRelativeStartTime: 2/10, relativeDuration: 2/10) { [weak self] in
//                guard let self = self else { return }
//                self.setNeedsStatusBarAppearanceUpdate()
//            }
            UIView.addKeyframe(withRelativeStartTime: 2/10, relativeDuration: 5/10) { [weak self] in
                guard let self = self else { return }
                if !inProcessOfLogin {
                    self.signInButton.alpha = 1.0
                }
                self.facebookAppleStackView.alpha = 0.0
                self.orView.alpha = 0.0
                self.goToView.alpha = 0.0
            }
        }) { _ in
            
        }
    }
    
    func adjustUIForKeyboardDisappearance(inProcessOfLogin: Bool,
                                          completion: (() -> Void)?) {
        UIView.animateKeyframes(withDuration: .animationDuration, delay: 0, options: [.calculationModeLinear, .beginFromCurrentState], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 5/10) { [weak self] in
                guard let self = self else { return }
                self.headerView.snp.updateConstraints {
                    $0.top.equalToSuperview()
                }
                self.loginFormsContainer.snp.updateConstraints {
                    $0.top.lessThanOrEqualTo(self.headerView.snp.bottom).offset(CGFloat.loginFormsContainerTopOffset)
                }
                self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(withRelativeStartTime: 2/10, relativeDuration: 5/10) { [weak self] in
                guard let self = self else { return }
                if !inProcessOfLogin {
                    self.signInButton.alpha = 0.0
                }
            }
            UIView.addKeyframe(withRelativeStartTime: 2/10, relativeDuration: 5/10) { [weak self] in
                guard let self = self else { return }
                if !inProcessOfLogin {
                    self.facebookAppleStackView.alpha = 1.0
                    self.orView.alpha = 1.0
                    self.goToView.alpha = 1.0
                }
            }
            // Temporarily disabled
//            UIView.addKeyframe(withRelativeStartTime: 8/10, relativeDuration: 2/10) { [weak self] in
//                guard let self = self else { return }
//                self.setNeedsStatusBarAppearanceUpdate()
//            }
        }) { _ in
            if let completion = completion {
                completion()
            }
            // Temporarily disabled
//            UIView.animate(withDuration: .animationDuration / 2) {
//                self?.closeButton.isHidden = false
//                self?.closeButton.alpha = 1.0
//            }
        }
    }
    
    func closeViewController() {
        if let delegate = delegate {
            delegate.loginViewWillBeClosed()
        } else {
            UIView.animate(withDuration: 0.15) { [weak self] in
                self?.closeButton.alpha = 0.0
                self?.headerView.alpha = 0.0
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func showSuccessAlertAndCloseViewController(with text: String) {
        let hudDuration = 1.0
        IHProgressHUD.setMaxSupportedWindowLevel(maxSupportedWindowLevel: .statusBar)
        IHProgressHUD.set(maximumDismissTimeInterval: hudDuration)
        IHProgressHUD.setHapticsEnabled(hapticsEnabled: true)
        IHProgressHUD.showSuccesswithStatus(text)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { [weak self] in
            self?.closeViewController()
        }
    }
    
    func showSuccessAlert(with text: String) {
        IHProgressHUD.setMaxSupportedWindowLevel(maxSupportedWindowLevel: .statusBar)
        IHProgressHUD.set(maximumDismissTimeInterval: 1.4)
        IHProgressHUD.setHapticsEnabled(hapticsEnabled: true)
        IHProgressHUD.showSuccesswithStatus(text)
    }
    
    func showErrorAlert(with text: String) {
        IHProgressHUD.setMaxSupportedWindowLevel(maxSupportedWindowLevel: .statusBar)
        IHProgressHUD.set(maximumDismissTimeInterval: 1.4)
        IHProgressHUD.setHapticsEnabled(hapticsEnabled: true)
        IHProgressHUD.showError(withStatus: text)
    }
    
    func showLoaderAlert() {
        IHProgressHUD.setMaxSupportedWindowLevel(maxSupportedWindowLevel: .statusBar)
        IHProgressHUD.set(defaultMaskType: .clear)
        IHProgressHUD.show()
    }
    
    func dismissLoaderAlert() {
        IHProgressHUD.setMaxSupportedWindowLevel(maxSupportedWindowLevel: .statusBar)
        IHProgressHUD.dismiss()
    }
    
    func showPopUp(from view: UIView, with model: PopViewModelsFactory.Model) {
        let fromRect = loginFormsContainer.convert(view.frame, to: self.view)
        let newFromRect = CGRect(x: fromRect.minX,
                                 y: fromRect.minY + 12,
                                 width: fromRect.width / 3,
                                 height: fromRect.height)
        let popView = PopView()
        popView.bubbleOffset = 14
        popView.padding = 12
        popView.arrowSize = CGSize(width: 16, height: 7)
        popView.actionAnimation = .float(offsetX: 0, offsetY: 3)
        popView.actionAnimationIn = 1.75
        popView.entranceAnimation = .scale
        popView.animationIn = 0.6
        popView.animationOut = 0.25
        popView.exitAnimation = .scale
        popView.bubbleColor = model.color
        popView.cornerRadius = model.cornerRadius
        popView.font = model.font
        popView.textColor = .white
        popView.shouldDismissOnSwipeOutside = true
        popView.show(text: model.title, direction: .up, maxWidth: model.maxWidth, in: self.view, from: newFromRect)
        self.popView = popView
    }
    
    func dismissPopUp() {
        if let popView = popView {
            popView.hide()
        }
    }
}

// MARK: - Private Extensions

private extension TimeInterval {
    static let animationDuration = 0.45
}

private extension CGFloat {
    static let loginFormsContainerTopOffset: CGFloat = 40
}
