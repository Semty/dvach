//
//  HeaderView.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 18.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation
import UIKit

final class HeaderView: UIView {

    // UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .n7Blue
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .n2Gray
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        
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
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        titleLabel.snp.makeConstraints { $0.leading.trailing.equalToSuperview().inset(24)
            if UIDevice.current.hasNotch {
                $0.top.equalToSuperview().inset(66)
            } else {
                $0.top.equalToSuperview().inset(40)
            }
        }
        subtitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(42)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16).priority(.high)
        }
    }
}

// MARK: - ConfigurableView

extension HeaderView: ConfigurableView {
    
    struct ConfigurationModel {
        let title: String
        let subtitle: String
        let animate: Bool
    }
    
    func configure(with model: ConfigurationModel) {
        if model.animate {
            UIView.transition(with: titleLabel, duration: .animationDuration, options: .transitionCrossDissolve, animations: { [weak self] in
                self?.titleLabel.text = model.title
            }, completion: nil)
            UIView.transition(with: subtitleLabel, duration: .animationDuration, options: .transitionCrossDissolve, animations: { [weak self] in
                self?.subtitleLabel.text = model.subtitle
            }, completion: nil)
        } else {
            titleLabel.text = model.title
            subtitleLabel.text = model.subtitle
        }
    }
}

private extension TimeInterval {
    static let animationDuration = 0.45
}

private extension CGFloat {
    static let titleHeight: CGFloat = 29
    static let subtitleHeight: CGFloat = 29
}
