//
//  CategoriesCardView.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

typealias CategoriesCardCell = CollectionViewContainerCellBase<CategoriesCardView>

final class CategoriesCardView: UIView, ConfigurableView, ReusableView {
    
    // Nested
    struct Model {
        let image: UIImage
        let title: String
        let subtitle: String
    }
    
    // Outlets
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    // MARK: - Lyfecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .n4Red
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model

    func configure(with model: CategoriesCardView.Model) {
        icon.image = model.image
        title.text = model.title
        subtitle.text = model.subtitle
    }
}
