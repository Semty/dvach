//
//  LoginViewController.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 17.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

protocol ILoginViewControllerDelegate: class {
    func loginViewWillBeClosed()
}

final class LoginViewController: UIViewController {

    // Delegate
    public weak var delegate: ILoginViewControllerDelegate?
    
    // Dependencies
    internal let presenter: ILoginPresenter
    internal let componentsFactory: IComponentsFactory
    
    // UI
    internal lazy var headerView: HeaderView = {
        let view = HeaderView()
        return view
    }()
    
    internal lazy var loginFormsContainer: LoginFormsView = {
        let view = LoginFormsView()
        return view
    }()
    
    internal lazy var forgotPasswordView: LoginForgotPasswordView = {
        let view = LoginForgotPasswordView()
        view.enablePressStateAnimation { [weak self] in
            self?.forgotPasswordAction()
        }
        view.isHidden = true
        return view
    }()
    
    internal lazy var facebookAppleStackView: UIStackView = {
        let facebookAppleStackView = UIStackView()
        facebookAppleStackView.spacing = 16
        facebookAppleStackView.axis = .vertical
        facebookAppleStackView.addArrangedSubview(facebookButton)
//        if #available(iOS 13.0, *) {
//            facebookAppleStackView.addArrangedSubview(appleButton)
//        }
        facebookAppleStackView.alpha = 0.0
        return facebookAppleStackView
    }()
    
//    @available(iOS 13.0, *)
//    internal lazy var appleButton: BottomButton = {
//        let button = BottomButton()
//        let model = BottomButton.Model(text: .apple,
//                                       image: .apple,
//                                       backgroundColor: .appleColor,
//                                       textColor: .white)
//        button.configure(with: model)
//        button.enablePressStateAnimation { [weak self] in
//            self?.appleButtonAction()
//        }
//        return button
//    }()
    
    internal lazy var facebookButton: BottomButton = {
        let button = BottomButton()
        let model = BottomButton.Model(text: .facebook,
                                       image: .facebook,
                                       backgroundColor: .facebookColor,
                                       textColor: .white)
        button.configure(with: model)
        button.enablePressStateAnimation { [weak self] in
            self?.facebookButtonAction()
        }
        return button
    }()
    
    internal lazy var emailButton: BottomButton = {
        let button = BottomButton()
        let model = BottomButton.Model(text: .email,
                                       image: .email,
                                       backgroundColor: .emailColor,
                                       textColor: .white)
        button.configure(with: model)
        button.enablePressStateAnimation { [weak self] in
            self?.emailButtonAction()
        }
        button.alpha = 0.0
        return button
    }()
    
    internal lazy var signInButton: BottomButton = {
        let button = BottomButton()
        button.disabledColor = Theme.current.mainColor
        button.isEnabled = false
        button.enablePressStateAnimation { [weak self] in
            self?.signInButtonAction()
        }
        button.alpha = 0.0
        return button
    }()
    
    internal lazy var signOutButton: BottomButton = {
        let button = BottomButton()
        button.configure(with: BottomButton.Model(text: .logOut,
                                                  image: nil,
                                                  backgroundColor: .logOutColor,
                                                  textColor: .white))
        button.enablePressStateAnimation { [weak self] in
            self?.signOutButtonAction()
        }
        button.alpha = 0.0
        return button
    }()
    
    internal lazy var goToView: LoginSignInSignUpView = {
        let view = LoginSignInSignUpView()
        view.enablePressStateAnimation { [weak self] in
            self?.goToAction()
        }
        view.alpha = 0.0
        return view
    }()
    
    internal lazy var orView: OrView = {
        let view = OrView()
        view.alpha = 0.0
        return view
    }()
    
    internal lazy var closeButton =
        componentsFactory.createCloseButton(
            style: .mo,
            imageColor: .closeColor,
            backgroundColor: nil,
            completion: { [weak self] in self?.closeButtonAction() }
    )
    
    internal weak var popView: PopView?
    
    // Private Interface
    internal var keyboardHeight: CGFloat?
    
    // Override
    
    // Temporarily disabled
//    override var prefersStatusBarHidden: Bool {
//        return keyboardIsShown
//    }
//
//    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
//        return .slide
//    }
    
    // Public
    public var keyboardIsShown = false
    public var isPopViewPrersented: Bool {
        return popView != nil
    }
    
    // MARK: - Initialize
    
    init(presenter: ILoginPresenter, componentsFactory: IComponentsFactory) {
        self.presenter = presenter
        self.componentsFactory = componentsFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\n\nLoginViewController deinit\n\n")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotifications()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(headerView)
        view.addSubview(loginFormsContainer)
        view.addSubview(forgotPasswordView)
        view.addSubview(goToView)
        view.addSubview(facebookAppleStackView)
        view.addSubview(orView)
        view.addSubview(emailButton)
        view.addSubview(signInButton)
        view.addSubview(closeButton)
        view.addSubview(signOutButton)
        
        headerView.snp.makeConstraints { $0.leading.trailing.top.equalToSuperview() }
        loginFormsContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(CGFloat.commonLeadingTrailing)
            $0.top.lessThanOrEqualTo(headerView.snp.bottom).offset(CGFloat.loginFormsContainerTopOffset)
        }
        forgotPasswordView.snp.makeConstraints {
            $0.top.equalTo(loginFormsContainer.snp.bottom).offset(CGFloat.forgotPasswordToCreateAccountOffset)
            $0.leading.trailing.equalToSuperview().inset(CGFloat.commonLeadingTrailing)
            $0.centerX.equalToSuperview()
        }
        goToView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeArea.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(CGFloat.commonLeadingTrailing)
        }
        facebookAppleStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(CGFloat.commonLeadingTrailing)
            $0.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualTo(goToView.snp.top).offset(-36)
        }
        signOutButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeArea.bottom).inset(20)
            $0.leading.trailing.equalToSuperview().inset(CGFloat.commonLeadingTrailing)
        }
        orView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(facebookAppleStackView.snp.top).offset(CGFloat.authButtonsDelimiterOffset)
        }
        emailButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(CGFloat.commonLeadingTrailing)
            $0.bottom.equalTo(orView.snp.top).offset(CGFloat.authButtonsDelimiterOffset)
        }
        signInButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(CGFloat.commonLeadingTrailing)
            $0.top.equalTo(forgotPasswordView.snp.bottom).offset(CGFloat.forgotPasswordToCreateAccountOffset)
        }
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeArea.top).offset(CGFloat.closeButtonTopOffset)
            $0.trailing.equalTo(view.safeArea.trailing).inset(4)
        }
    }
    
    // MARK: - Setup Notifications
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UI Fixes
    
    internal func fixSomeUIOnIphone5(with state: LoginPresenter.State) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            switch state {
            case .start, .logIn, .logOut:
                self.orView.snp.updateConstraints {
                    $0.bottom.equalTo(self.facebookAppleStackView.snp.top).offset(CGFloat.authButtonsDelimiterOffset)
                }
            case .signUp:
                self.orView.snp.updateConstraints {
                    $0.bottom.equalTo(self.facebookAppleStackView.snp.top).offset(CGFloat.authButtonsDelimiterOffset/2)
                }
            }
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    
//    @objc private func appleButtonAction() {
//        presenter.appleButtonTapped()
//    }
    
    @objc private func facebookButtonAction() {
        presenter.facebookButtonTapped()
    }
    
    @objc private func emailButtonAction() {
        presenter.emailButtonTapped()
    }
    
    @objc private func signInButtonAction() {
        presenter.signInButtonTapped()
    }
    
    @objc private func forgotPasswordAction() {
        presenter.forgotPasswordButtonTapped()
    }
    
    @objc private func signOutButtonAction() {
        presenter.signOutButtonTapped()
    }
    
    private func closeButtonAction() {
        presenter.closeButtonTapped()
    }
    
    private func goToAction() {
        guard let title = goToView.title else { return }
        if title.contains(String.toLoginButton) {
            presenter.toLoginButtonTapped()
        } else if title.contains(String.toSignUpButton) {
            presenter.toSignUpButtonTapped()
        }
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: view)
//            let subview = view.hitTest(location, with: event)
            
            if isPopViewPrersented {
                dismissPopUp()
            }
            if keyboardIsShown {
                if !signInButton.frame.contains(location) && !closeButton.frame.contains(location) &&
                    (!forgotPasswordView.frame.contains(location) || forgotPasswordView.isHidden) {
                    view.endEditing(true)
                }
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - Keyboard Notifications
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        guard let isKeyboardBelongsToOurApp = notification.isKeyboardBelongsToOurApp() else { return }
        
        if isKeyboardBelongsToOurApp {
            if let keyboardHeight = notification.keyboardHeight(),
                keyboardHeight > 160 {
                //print("\nKEYBOARD HEIGHT = \(keyboardHeight)")
                self.keyboardHeight = keyboardHeight
                if !keyboardIsShown {
                    //print("keyboardWillAppear")
                    if isPopViewPrersented {
                        popView?.hide()
                    }
                    keyboardIsShown = true
                    presenter.keyboardWillAppear()
                }
            }
        }
    }

    @objc func keyboardWillDisappear(_ notification: Notification) {
        guard let isKeyboardBelongsToOurApp = notification.isKeyboardBelongsToOurApp() else { return }
        
        if isKeyboardBelongsToOurApp {
            if let keyboardHeight = notification.keyboardHeight(),
                keyboardHeight > 160 {
                //print("\nKEYBOARD HEIGHT = \(keyboardHeight)")
                self.keyboardHeight = keyboardHeight
                if keyboardIsShown {
                    //print("keyboardWillDisappear")
                    keyboardIsShown = false
                    presenter.keyboardWillDisappear()
                }
            }
        }
    }
    
    // MARK: - Private
    
    internal func calculateLoginFormsTopOffsetDuringKeyboardApperance() -> CGFloat? {
        guard let keyboardHeight = keyboardHeight else { return nil }
        let loginFormsContainerHeight: CGFloat
        if forgotPasswordView.isHidden {
            loginFormsContainerHeight =
            loginFormsContainer.bounds.height
                + .loginFormsToCreateAccountOffset
                + signInButton.bounds.height
        } else {
            loginFormsContainerHeight =
            loginFormsContainer.bounds.height
                + .forgotPasswordToCreateAccountOffset * 2
                + signInButton.bounds.height
                + forgotPasswordView.bounds.height
        }
        let topSafeArea = UIDevice.safeAreaTopInset
        let appearanceFrame = Screen.bounds.height - keyboardHeight
        let topOffset = (appearanceFrame - loginFormsContainerHeight) / 2 + (topSafeArea / 2)
        return topOffset
    }
}

// MARK: - Private Extensions

private extension UIColor {
    static let backgroundColor = Theme.current.backgroundColor
    static let facebookColor = Theme.current.facebookColor
    static let appleColor = Theme.current.appleColor
    static let emailColor = Theme.current.mainColor
    static let closeColor = Theme.current.awesomeBlackColor
    static let createAccountColor = Theme.current.mainColor
    static let logOutColor = Theme.current.mainColor
}

private extension CGFloat {
    static let staticViewContainerViewHeight: CGFloat = 49
    static let commonLeadingTrailing: CGFloat = 24
    static let facebookAppleStackViewBottomInset: CGFloat = 36
    static let loginFormsContainerTopOffset: CGFloat = 40
    static let loginFormsContainerNotchableTopOffset: CGFloat = loginFormsContainerTopOffset + 26
    static let authButtonsDelimiterOffset: CGFloat = -32
    static let closeButtonTopOffset: CGFloat = -6
    static let loginFormsToCreateAccountOffset: CGFloat = 24
    static let forgotPasswordToCreateAccountOffset: CGFloat = 18
}

private extension UIImage {
    static let facebook = AppConstants.Images.Login.facebook
    static let apple = AppConstants.Images.Login.apple
    static let email = AppConstants.Images.Login.authEmail
    static let close = AppConstants.Images.close
}

private extension String {
    static let email = AppConstants.Strings.Login.AuthType.email
    static let facebook = AppConstants.Strings.Login.AuthType.facebook
    static let apple = AppConstants.Strings.Login.AuthType.apple
    static let logOut = AppConstants.Strings.Login.logOut
    
    static let toLoginButton = AppConstants.Strings.Login.AccountAvailability.toLoginButton
    static let toSignUpButton = AppConstants.Strings.Login.AccountAvailability.toSignUpButton
}
