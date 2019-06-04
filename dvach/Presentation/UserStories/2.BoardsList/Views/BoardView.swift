//
//  BoardView.swift
//  dvach
//
//  Created by Kirill Solovyov on 04/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

typealias BoardCell = TableViewContainerCellBase<BoardView>

private extension SeparatorInsets {
    static let separatorInsets = SeparatorInsets(72, .inset16)
}

final class BoardView: UIView, ConfigurableView, SeparatorAvailable, ReusableView {
    
    // Nested
    struct Model {
        let title: String
        let subtitle: String
        let icon: UIImage
    }
    
    // Outlets
    @IBOutlet weak var iconView: IconView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .n1Gray
        subtitleLabel.textColor = .n2Gray
        addBottomSeparator(with: .init(insets: .separatorInsets))
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: BoardView.Model) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        let iconViewModel = IconView.Model(icon: model.icon, text: model.title)
        iconView.configure(with: iconViewModel)
    }
}
