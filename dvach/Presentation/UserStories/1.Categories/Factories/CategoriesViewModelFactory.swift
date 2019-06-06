//
//  CategoriesViewModelFactory.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension Int {
    static let maxModelsCount = 10
}

final class CategoriesViewModelFactory {
    
    // MARK: - Public
    
    func createViewModels(category: Category, boards: [Board]) -> CategoriesPresenter.BlockModel? {
        guard !boards.isEmpty else { return nil }
        let buttonTitle = boards.count > 5 ? "Все" : nil
        let blockModel = BlockWithTitle.Model(title: category.rawValue, buttonTitle: buttonTitle)
        let cardsModels = collectionModels(category: category, boards: boards)
        
        return CategoriesPresenter.BlockModel(category: category,
                                              blockModel: blockModel,
                                              collectionModels: cardsModels)
    }
    
    // MARK: - Private
    
    private func collectionModels(category: Category, boards: [Board]) -> [CategoriesCardView.Model] {
        return boards.prefix(.maxModelsCount).map {
            let icon: UIImage
            if let assetsIcon = UIImage(named: $0.identifier) {
                icon = assetsIcon
            } else {
                icon = UIImage(named: "default") ?? UIImage()
            }
            return CategoriesCardView.Model(image: icon, title: $0.name, subtitle: "\\\($0.identifier)\\")
        }
    }
}
