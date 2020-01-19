//
//  LoginForgotPasswordView.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 29.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

final class LoginForgotPasswordView: UIView, PressStateAnimatable {
    
    // Private Interface
    private let textAttributes = String.attributes(withFont: UIFont(), textAlignment: .center)
    
    // UI
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let string: String = "forgotPassword"
        let text = string.withAttributes(textAttributes).mutableCopy() as! NSMutableAttributedString
        text.addAttribute(.font,
                          value: UIFont.font,
                          range: (text.string as NSString).range(of: text.string))
        text.addAttribute(.foregroundColor,
                          value: .white,
                          range: (text.string as NSString).range(of: .pressHere))
        label.attributedText = text
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

// MARK: - Private Extensions

private extension CGFloat {
    static let height: CGFloat = 16
}
