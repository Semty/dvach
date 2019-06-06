//
//  CategoriesCardView.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

typealias CategoriesCardCell = CollectionViewContainerCellBase<CategoriesCardView>

final class CategoriesCardView: UIView, ConfigurableView, ReusableView, PressStateAnimatable {
    
    // Nested
    struct Model {
        let image: UIImage
        let title: String
        let subtitle: String
    }
    
    // Outlets
    @IBOutlet weak var icon: IconView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    // MARK: - Lyfecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        title.textColor = .n1Gray
        subtitle.textColor = .n2Gray
        makeRoundedByCornerRadius(10)
        enablePressStateAnimation()
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model

    func configure(with model: CategoriesCardView.Model) {
        let iconViewModel = IconView.Model(icon: model.image, text: model.title)
        icon.configure(with: iconViewModel)
        title.text = model.title
        subtitle.text = model.subtitle
    }
}
