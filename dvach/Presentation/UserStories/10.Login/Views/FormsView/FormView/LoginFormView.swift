//
//  LoginFormView.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 18.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation
import UIKit

final class LoginFormView: UIView {

    // UI
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentContainer: UIView!
    
    // Private Interface
    private var state: State = .default
    
    private weak var textField: LoginTextField? {
        guard let subviewOfContentContainer = contentContainer.subviews.first else { return nil }
        return subviewOfContentContainer.subviews.first as? LoginTextField
    }
    
    private weak var validateView: LoginValidateView? {
        guard let subviewOfContentContainer = contentContainer.subviews.first else { return nil }
        return subviewOfContentContainer.subviews.last as? LoginValidateView
    }
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        layer.borderWidth = 1
        iconImageView.tintColor = .a1Green
        setupUI()
    }
    
    // MARK: - Layout Subviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstResponder {
            layer.borderColor = UIColor.n7Blue.cgColor
        } else {
            layer.borderColor = UIColor.n7Blue.cgColor
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        makeRoundedByCornerRadius(.cornerRadius)
        snp.makeConstraints { $0.height.equalTo(CGFloat.height) }
    }
    
    // MARK: - Public
    
    public var type: UITextContentType? {
        return textField?.textContentType
    }
    
    public var validity: LoginValidateView.State {
        return validateView?.state ?? .hidden
    }
    
    public func reloadConstraints() {
        snp.makeConstraints { $0.height.equalTo(CGFloat.height) }
    }
}

// MARK: - Configurable View

extension LoginFormView: ConfigurableView {
    
    enum State {
        case `default`
        case valid
        case invalid
    }
    
    struct ConfigurationModel {
        let image: UIImage
        let contentView: UIView
    }
    
    func configure(with model: ConfigurationModel) {
        iconImageView.image = model.image
        if contentContainer.subviews.isEmpty {
            contentContainer.addSubview(model.contentView)
            model.contentView.snp.makeConstraints({ $0.edges.equalToSuperview()})
        }
    }
}

// MARK: - Update

extension LoginFormView {
    
    func update(state: State) {
        if self.state != state {
            switch state {
            case .default:
                validateView?.configure(with: LoginValidateView.ConfigurationModel(state: .hidden))
            case .valid:
                validateView?.configure(with: LoginValidateView.ConfigurationModel(state: .valid))
            case .invalid:
                validateView?.configure(with: LoginValidateView.ConfigurationModel(state: .invalid))
            }
        }
    }
    
    func updatePasswordType(_ type: UITextContentType) {
        textField?.textContentType = type
    }
}

// MARK: - Responder

extension LoginFormView {
    
    override var isFirstResponder: Bool {
        return textField?.isFirstResponder ?? false
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        if (textField?.canBecomeFirstResponder ?? false) && !isFirstResponder {
            textField?.becomeFirstResponder()
            return true
        } else {
            return false
        }
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        if (textField?.canResignFirstResponder ?? false) && isFirstResponder {
            textField?.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
}

// MARK: - Reusable View

extension LoginFormView: ReusableView {
    
    func prepareForReuse() {
        iconImageView.image = nil
        contentContainer.removeAllSubviews()
    }
}

// MARK: - Private Extensions

private extension CGFloat {
    static var cornerRadius: CGFloat = 8
    static var height: CGFloat = 49
}
