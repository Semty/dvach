//
//  BlockWithTitle.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final public class BlockWithTitle: UIView, ConfigurableView, SeparatorAvailable {
    
    // Nested
    public struct Model {
        let title: String
        let buttonTitle: String?
    }
    
    // Outlets
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var stackView: UIStackView!
    
    // Properties
    public var action: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        title.textColor = .n1Gray
        button.tintColor = .n7Blue
        addBottomSeparator(with: .defaultStyle)
    }
    
    // MARK: - Public
    
    public func addView(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    // MARK: - Actions
    
    @IBAction func buttonAction(_ sender: Any) {
        action?()
    }
    
    // MARK: - ConfigurableView
    
    public typealias ConfigurationModel = Model

    public func configure(with model: BlockWithTitle.Model) {
        title.text = model.title
        button.setTitle(model.buttonTitle, for: .normal)
        button.isHidden = model.buttonTitle == nil
    }
}
