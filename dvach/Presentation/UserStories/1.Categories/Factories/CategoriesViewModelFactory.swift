//
//  CategoriesViewModelFactory.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class CategoriesViewModelFactory {
    
    // MARK: - Public
    
    func createViewModels(category: Category, boards: [Board]) -> CategoriesPresenter.BlockModel {
        let blockModel = BlockWithTitle.Model(title: category.rawValue, buttonTitle: "Все") {
            print("\(category.rawValue) pressed")
        }
        let cardsModels = collectionModels(category: category, boards: boards)
        
        return CategoriesPresenter.BlockModel(category: category,
                                              blockModel: blockModel,
                                              collectionModels: cardsModels)
    }
    
    // MARK: - Private
    
    private func collectionModels(category: Category, boards: [Board]) -> [CategoriesCardView.Model] {
        return boards.map {
            CategoriesCardView.Model(image: UIImage(), title: $0.name, subtitle: "\\\($0.identifier)\\")
        }
    }
}
