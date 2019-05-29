//
//  ContentContainer.swift
//  FatFood
//
//  Created by Kirill Solovyov on 06.11.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension UIEdgeInsets {
    static let insets = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
}

final class ContantContainer: UIView {
    
    private let content: UIView
    
    init(contantView: UIView) {
        self.content = contantView
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(content)
        content.autoPinEdgesToSuperviewEdges(with: .insets)
    }
}

extension UIView {
    
    var wrappedInContantContainer: UIView {
        return ContantContainer(contantView: self)
    }
}
