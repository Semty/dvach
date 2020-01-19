//
//  LoginFormsView.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 18.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

final class LoginFormsView: UIView {
    
    // Constraints
    private var loginFormsHeightConstraint: Constraint?
    
    private var loginFormsContainerHeight: CGFloat {
        var height: CGFloat = 0
        if !subviews.isEmpty {
            for (index, subview) in subviews.enumerated() {
                if index > 0 {
                    height += CGFloat.loginFormsContainerSpacing
                }
                height += subview.bounds.height
            }
        }
        return height
    }
    
    // Private Interface
    private var state: State = .hidden
    private var loginFormViews: [LoginFormView] {
        return subviews.compactMap { $0 as? LoginFormView }
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Private
    
    private func setup() {
        snp.makeConstraints {
            loginFormsHeightConstraint = $0.height.equalTo(loginFormsContainerHeight).constraint
        }
    }
    
    private func addOrUpdateForms(_ forms: [LoginFormView], reload: Bool = false) {
        for (index, form) in forms.enumerated() {
            if reload {
                if index == 0 {
                    form.snp.makeConstraints {
                        $0.leading.trailing.equalToSuperview()
                        $0.top.equalToSuperview()
                    }
                } else if let previousForm = forms[safeIndex: index-1] {
                    form.snp.makeConstraints {
                        $0.top.equalTo(previousForm.snp.bottom).offset(CGFloat.loginFormsContainerSpacing)
                        $0.leading.trailing.equalToSuperview()
                    }
                }
            } else {
                var formToWire: UIView?
                if let lastForm = subviews.last {
                    formToWire = lastForm
                }
                addSubview(form)
                form.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    if let formToWire = formToWire {
                        $0.top.equalTo(formToWire.snp.bottom).offset(CGFloat.loginFormsContainerSpacing)
                    } else {
                        $0.top.equalToSuperview()
                    }
                }
            }
        }
    }
    
    private func updateForms(_ forms: [LoginFormView], previousState: State, newState: State, initialSetup: Bool, completion: (() -> Void)?) {
        animateAlpha(newState == .hidden)
        if initialSetup {
            addOrUpdateForms(forms)
            updateUI(animatable: false, completion: completion)
        } else {
            switch newState {
            case .hidden:
                break
            case .logIn:
                if subviews.count > forms.count {
                    var offset = 0
                    loginFormViews.enumerated().forEach { (index, form) in
                        if let newForm = forms[safeIndex: index-offset],
                            form.type != newForm.type {
                            form.removeFromSuperview()
                            offset += 1
                        }
                    }
                    loginFormViews.forEach {
                        $0.snp.removeConstraints()
                        $0.reloadConstraints()
                    }
                    addOrUpdateForms(loginFormViews, reload: true)
                }
            case .signUp:
                if subviews.count < forms.count {
                    var offset = 0
                    forms.enumerated().forEach { (index, form) in
                        if let currentForm = loginFormViews[safeIndex: offset],
                            form.type != currentForm.type {
                            insertSubview(form, at: index)
                        } else {
                            offset += 1
                        }
                    }
                    loginFormViews.forEach {
                        $0.snp.removeConstraints()
                        $0.reloadConstraints()
                    }
                    addOrUpdateForms(loginFormViews, reload: true)
                }
            }
            updateUI(animatable: true, completion: completion)
        }
        state = newState
    }
    
    private func animateAlpha(_ isHidden: Bool) {
        if self.isHidden != isHidden {
            if self.isHidden {
                self.isHidden = false
                alpha = 0.0
            }
            let newAlpha: CGFloat = isHidden ? 0.0 : 1.0
            UIView.animate(withDuration: .animationDuration, animations: {
                self.alpha = newAlpha
            }) { _ in
                self.isHidden = isHidden
            }
        }
    }
    
    private func updateUI(animatable: Bool, completion: (() -> Void)?) {
        if animatable {
            UIView.animate(withDuration: .animationDuration, animations: { [weak self] in
                guard let self = self else { return }
                self.layoutIfNeeded()
            }) { _ in
                self.loginFormsHeightConstraint?.update(offset: self.loginFormsContainerHeight)
                if let completion = completion {
                    completion()
                }
            }
        } else {
            loginFormsHeightConstraint?.update(offset: loginFormsContainerHeight)
            layoutIfNeeded()
        }
    }
}

// MARK: - ConfigurableView

extension LoginFormsView {
    
    struct ConfigurationModel {
        let state: State
        let forms: [LoginFormView]
    }
    
    func configure(with model: ConfigurationModel, completion: (() -> Void)?) {
        updateForms(model.forms, previousState: state, newState: model.state, initialSetup: loginFormViews.isEmpty, completion: completion)
    }
}

// MARK: - Public

extension LoginFormsView {
    
    enum State {
        case hidden
        case logIn
        case signUp
    }
    
    func updateValidation(_ loginFormType: UITextContentType,
                          with state: LoginFormView.State) {
        for form in loginFormViews {
            if form.type == loginFormType {
                form.update(state: state)
                return
            }
        }
    }
    
    func update(_ loginFormType: UITextContentType) {
        loginFormViews.forEach { $0.setNeedsLayout() }
    }
    
    func forceLoginFormFirstResponder() {
        if let firstForm = loginFormViews.first {
            firstForm.becomeFirstResponder()
        }
    }
    
    func makeNextLoginFormFirstResponder() {
        for (index, subview) in loginFormViews.enumerated() {
            if subview.isFirstResponder {
                if let nextSubview = loginFormViews[safeIndex: index+1] {
                    nextSubview.becomeFirstResponder()
                    return
                } else {
                    subview.resignFirstResponder()
                }
            }
        }
        loginFormViews.forEach { $0.setNeedsLayout() }
    }
    
    func isThereFirstResponder() -> Bool {
        for form in loginFormViews {
            if form.isFirstResponder {
                return true
            }
        }
        return false
    }
}

// MARK: - Private Extensions

private extension CGFloat {
    static let loginFormsContainerSpacing: CGFloat = 16
}

private extension TimeInterval {
    static let animationDuration = 0.45
}
