//
//  FavouriteThreadView.swift
//  dvach
//
//  Created by Kirill Solovyov on 15/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

typealias FavouriteThreadCell = TableViewContainerCellBase<FavouriteThreadView>

private extension SeparatorInsets {
    static let separatorInsets = SeparatorInsets(100, .inset16)
}

final class FavouriteThreadView: UIView, SeparatorAvailable, ConfigurableView, ReusableView {
    
    // Nested
    struct Model {
        let title: String
        let subtitle: String
        let iconURL: String?
    }
    
    // Outlets
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .n1Gray
        subtitleLabel.textColor = .n2Gray
        image.makeRoundedByCornerRadius(.radius10)
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: FavouriteThreadView.Model) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        image.loadImage(url: model.iconURL ?? "", defaultImage: UIImage(named: "placeholder"))
    }
    
    // MARK: - Reusable
    
    func prepareForReuse() {
        addBottomSeparator(with: .init(insets: .separatorInsets))
    }
}
