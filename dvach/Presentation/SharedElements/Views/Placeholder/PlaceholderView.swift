//
//  PlaceholderView.swift
//  dvach
//
//  Created by k.a.solovyev on 30/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class PlaceholderView: UIView, ConfigurableView {
    
    // UI
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .n2Gray
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(CGFloat.inset20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = String
    
    func configure(with model: String) {
        placeholderLabel.text = model
    }
}
