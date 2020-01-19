//
//  LoginValidateView.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 18.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

final class LoginValidateView: UIView {

    // UI
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints({ $0.size.equalTo(CGFloat.side) })
        return imageView
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
        snp.makeConstraints { $0.height.width.equalTo(CGFloat.side) }
        addSubview(imageView)
        imageView.snp.makeConstraints({
            $0.leading.trailing.top.bottom.equalToSuperview()
        })
    }
    
    // MARK: - Public
    
    public var state: State = .hidden
}

// MARK: - ConfigurableView

extension LoginValidateView: ConfigurableView {
    
    struct ConfigurationModel {
        let state: State
    }
    
    func configure(with model: ConfigurationModel) {
        
        UIView.animate(withDuration: .stateChangingDuration) { [weak self] in
            guard let self = self else { return }
            
            switch model.state {
            case .hidden:
                self.imageView.alpha = 0.0
                self.imageView.image = nil
            case .valid:
                self.imageView.alpha = 1.0
//                self.imageView.image = .valid
            case .invalid:
                self.imageView.alpha = 0.0
                self.imageView.image = nil
            }
            
            self.state = model.state
        }
    }
}

// MARK: - State

extension LoginValidateView {
    
    enum State {
        case hidden
        case valid
        case invalid
    }
}

// MARK: - Private Extensions

private extension CGFloat {
    static let side: CGFloat = 24
}

private extension TimeInterval {
    static let stateChangingDuration: TimeInterval = 0.45
}

private extension UIImage {
    static let valid = AppConstants.Images.Login.valid
    static let invalid = AppConstants.Images.Login.invalid
}
