//
//  LoginSignInSignUpView.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 29.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

final class LoginSignInSignUpView: UIView, PressStateAnimatable {
    
    // UI
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
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
        addSubview(label)
        snp.makeConstraints({ $0.height.equalTo(CGFloat.height) })
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: - Public
    
    public var title: String? {
        return label.text
    }
}

// MARK: - ConfigurableView

extension LoginSignInSignUpView: ConfigurableView {
    
    struct ConfigurationModel {
        let text: NSMutableAttributedString
    }
    
    func configure(with model: ConfigurationModel) {
//        label.attributedText = model.text
    }
}

// MARK: - Private Extensions

private extension CGFloat {
    static let height: CGFloat = 20
}
