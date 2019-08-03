//
//  SeparatorView.swift
//  dvach
//
//  Created by Kirill Solovyov on 03/08/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

public final class SeparatorView: UIView {
    
    // Properties
    private let insets: SeparatorInsets
    
    // UI
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .n5LightGray
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    init(insets: SeparatorInsets) {
        self.insets = insets
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = .clear
        snp.makeConstraints { $0.height.equalTo(1 / UIScreen.main.scale) }
        
        addSubview(separator)
        separator.snp.makeConstraints { $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: insets.left, bottom: 0, right: insets.right)) }
    }
}
