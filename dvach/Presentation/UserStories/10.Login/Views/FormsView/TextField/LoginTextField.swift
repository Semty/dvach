//
//  LoginTextField.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 18.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

final class LoginTextField: UITextField {
    
    // Dependencies
    private lazy var metrics: MetricsManager = Locator.shared.metricsManager()
    
    // Model
    private var onTap: ((String, UITextContentType) -> Void)?
    private var onBegin: ((String, UITextContentType) -> Void)?
    private var onChange: ((String, UITextContentType) -> Void)?
    private var onEnd: ((String, UITextContentType) -> Void)?
    private var onReturnKey: ((String, UIReturnKeyType, UITextContentType) -> Void)?
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .font
        smartInsertDeleteType = .yes
        enablesReturnKeyAutomatically = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Override
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        if canBecomeFirstResponder && !isFirstResponder {
            guard let textContentType = textContentType else { return super.becomeFirstResponder() }
            switch textContentType {
            case .name:
                metrics.signUpInputFocus(input: .name)
            case .password:
                metrics.signUpInputFocus(input: .password)
            case .emailAddress:
                metrics.signUpInputFocus(input: .email)
            default: break
            }
            if #available(iOS 12.0, *) {
                if textContentType == .newPassword {
                    metrics.signUpInputFocus(input: .newPassword)
                }
            }
            return super.becomeFirstResponder()
        } else {
            return super.becomeFirstResponder()
        }
    }
    
    // MARK: - Private
    
    private func setup() {
        snp.makeConstraints({ $0.height.equalTo(CGFloat.height) })
        addTarget(self, action: #selector(didTap), for: .touchDown)
        addTarget(self, action: #selector(valueDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(valueDidChange), for: .editingChanged)
        addTarget(self, action: #selector(valueDidEnd), for: .editingDidEnd)
        addTarget(self, action: #selector(returnKeyTriggered), for: .primaryActionTriggered)
    }
    
    // MARK: - Actions
    
    @objc private func didTap() {
        onTap?(text ?? "", textContentType)
    }
    
    @objc private func valueDidBegin() {
        onBegin?(text ?? "", textContentType)
    }
    
    @objc private func valueDidChange() {
        onChange?(text ?? "", textContentType)
    }
    
    @objc private func valueDidEnd() {
        onEnd?(text ?? "", textContentType)
    }
    
    @objc private func returnKeyTriggered() {
        let returnType = returnKeyType
        onReturnKey?(text ?? "", returnType, textContentType)
    }
}

// MARK: - ConfigurableView

extension LoginTextField: ConfigurableView {
    
    struct ConfigurationModel {
        let text: String?
        let placeholder: String?
        let contentType: UITextContentType
        let returnKeyType: UIReturnKeyType
        
        let onTap: (String, UITextContentType) -> Void
        let onBegin: (String, UITextContentType) -> Void
        let onChange: (String, UITextContentType) -> Void
        let onEnd: (String, UITextContentType) -> Void
        let onReturnKey: (String, UIReturnKeyType, UITextContentType) -> Void
    }
    
    func configure(with model: ConfigurationModel) {
        switch model.contentType {
        case .name:
            autocapitalizationType = .words
        case .emailAddress:
            autocapitalizationType = .none
            keyboardType = .emailAddress
        case .password:
            autocapitalizationType = .none
            keyboardType = .asciiCapable
        default: break
        }
        if #available(iOS 12.0, *) {
            if model.contentType == .newPassword {
                isSecureTextEntry = model.contentType == .newPassword
                autocapitalizationType = .none
                keyboardType = .asciiCapable
            } else {
                isSecureTextEntry = model.contentType == .password
            }
        } else {
            isSecureTextEntry = model.contentType == .password
        }
        returnKeyType = model.returnKeyType
        text = model.text
        textContentType = model.contentType
        attributedPlaceholder =
            NSAttributedString(string: model.placeholder ?? "",
                               attributes: [
                                .foregroundColor: UIColor.placeholderColor,
                                .font: UIFont.font
            ])
        
        onTap = model.onTap
        onBegin = model.onBegin
        onChange = model.onChange
        onReturnKey = model.onReturnKey
        onEnd = model.onEnd
    }
}

// MARK: - Private Extensions

private extension CGFloat {
    static let height: CGFloat = 41
}

private extension UIFont {
    static let font = AppConstants.Font.regular(size: 16)
}

private extension UIColor {
    static let placeholderColor = Theme.current.placeholderGrayishColor
}
