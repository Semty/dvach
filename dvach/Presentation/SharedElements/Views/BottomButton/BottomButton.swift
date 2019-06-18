//
//  BottomButton.swift
//  dvach
//
//  Created by Kirill Solovyov on 17/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension CGFloat {
    static let height: CGFloat = 45
}

final class BottomButton: UIView, ConfigurableView, PressStateAnimatable {
    
    struct Model {
        let text: String
        let backgroundColor: UIColor
        let textColor: UIColor
    }
    
    // UI
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: .size16)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
        makeRoundedByCornerRadius(.radius10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupUI() {
        snp.makeConstraints { $0.height.equalTo(CGFloat.height)}
        addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: BottomButton.Model) {
        label.text = model.text
        label.textColor = model.textColor
        backgroundColor = model.backgroundColor
    }
}
