//
//  CategoriesPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol ICategoriesPresenter {
    func viewDidLoad()
}

final class CategoriesPresenter {
    
    struct BlockModel {
        let category: Category
        let blockModel: BlockWithTitle.Model
        let collectionModels: [CategoriesCardView.Model]
    }
    
    // Dependencies
    weak var view: CategoriesView?
    private let dvachService = Locator.shared.dvachService()
    private let viewModelsFactory = CategoriesViewModelFactory()
    
    // MARK: - Private
    
    private func loadCategories() {
        dvachService.loadBoards { [weak self] result in
            switch result {
            case .success(let boards):
                let models = self?.createViewModels(boards: boards) ?? []
                DispatchQueue.main.async {
                    self?.view?.update(viewModels: models)
                }
            case .failure(let error):
                print(error)
                // TODO: показать ошибку
            }
        }
    }
    
    private func createViewModels(boards: [Board]) -> [BlockModel] {
        var japan = [Board]()
        var games = [Board]()
        
        boards.forEach {
            switch $0.category {
            case .japan?: japan.append($0)
            case .games?: games.append($0)
            default: break
            }
        }
        
        let japanBlock = viewModelsFactory.createViewModels(category: .japan, boards: japan)
        let gamesBlock = viewModelsFactory.createViewModels(category: .games, boards: games)
        
        return [japanBlock, gamesBlock]
    }
}

// MARK: - ICategoriesPresenter

extension CategoriesPresenter: ICategoriesPresenter {
    
    func viewDidLoad() {
        loadCategories()
    }
}
