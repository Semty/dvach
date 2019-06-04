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
        var japan = ([Board](), Category.japan)
        var games = ([Board](), Category.games)
        var politics = ([Board](), Category.politics)
        var other = ([Board](), Category.other)
        var art = ([Board](), Category.art)
        var theme = ([Board](), Category.theme)
        var technics = ([Board](), Category.technics)
        var user = ([Board](), Category.user)
        
        boards.forEach {
            switch $0.category {
            case .japan?: japan.0.append($0)
            case .games?: games.0.append($0)
            case .politics?: politics.0.append($0)
            case .user?: user.0.append($0)
            case .other?: other.0.append($0)
            case .art?: art.0.append($0)
            case .theme?: theme.0.append($0)
            case .technics?: technics.0.append($0)
            case nil: break
            default: break
            }
        }
        // Порядок блоков можно поменять тут
        let models = [other, user, theme, art, technics, games, politics, japan]
        
        return models.map { viewModelsFactory.createViewModels(category: $0.1, boards: $0.0)}
    }
}

// MARK: - ICategoriesPresenter

extension CategoriesPresenter: ICategoriesPresenter {
    
    func viewDidLoad() {
        loadCategories()
    }
}
