//
//  ShadowViewContainer.swift
//  Receipt
//
//  Created by Kirill Solovyov on 03.06.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

private enum Const {
    static let contentViewInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    static let contentViewShadowOpacity: Float = 0.3
    static let contentViewShadowRadius: CGFloat = 5
    static let shadowOffset: CGSize = CGSize(width: 1, height: 1)
}

public final class ShadowViewContainer: UIView, PressStateAnimatable {
    
    public var contentView: UIView? {
        didSet {
            setupUI()
        }
    }
    
    public let insets: UIEdgeInsets
    
    private lazy var shadowView = UIView()
    private lazy var borderView = UIView()

    // MARK: - Lifecycle
    
    public init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // add the shadow to the base view
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        shadowView.layer.shadowOffset = Const.shadowOffset
        shadowView.layer.shadowOpacity = Const.contentViewShadowOpacity
        shadowView.layer.shadowRadius = Const.contentViewShadowRadius
        
        // add the border to subview
        borderView.frame = shadowView.bounds
        borderView.backgroundColor = .white
        borderView.layer.cornerRadius = .radius10
        borderView.layer.masksToBounds = true
    }
    
    private func setupUI() {
        guard let contentView = contentView else { return }
        backgroundColor = .clear

        addSubview(shadowView)
        shadowView.addSubview(borderView)
        borderView.addSubview(contentView)
        
        shadowView.autoPinEdgesToSuperviewEdges(with: insets)
        borderView.autoPinEdgesToSuperviewEdges()
        contentView.autoPinEdgesToSuperviewEdges()
    }
}
