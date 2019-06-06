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
    func didSelectCell(indexPath: IndexPath, category: Category)
    func didTapAllBoards(category: Category)
    func didTap(board: Board)
}

final class CategoriesPresenter {
    
    typealias DataSource = ([Board], Category)
    
    // Nested
    struct BlockModel {
        let category: Category
        let blockModel: BlockWithTitle.Model
        let collectionModels: [CategoriesCardView.Model]
    }
    
    // Dependencies
    weak var view: (CategoriesView & UIViewController)?
    private let dvachService = Locator.shared.dvachService()
    private let viewModelsFactory = CategoriesViewModelFactory()
    
    // Properties
    private var models = [DataSource]()
    
    // MARK: - Private
    
    private func loadCategories() {
        dvachService.loadBoards { [weak self] result in
            switch result {
            case .success(let boards):
                let models = self?.createViewModels(boards: boards) ?? []
                DispatchQueue.main.async {
                    self?.view?.didLoadBoards(boards: boards)
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
        var adults = ([Board](), Category.adults)
        
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
            case .adults?: adults.0.append($0)
            case nil: break
            }
        }
        
        // По сути дефолтный порядок
        let categories = [other, theme, art, technics, games, politics, japan, user, adults]
        
        // Тут выставляется порядок блоков из конфга, если он есть
        if let order = Config.blocksOrder {
            models = order.compactMap { category in
                categories.first(where: { $0.1 == category })
            }
        } else {
            models = categories.dropLast() // кроме "Для взрослых"
        }
        
        
        return models.compactMap { viewModelsFactory.createViewModels(category: $0.1, boards: $0.0)}
    }
}

// MARK: - ICategoriesPresenter

extension CategoriesPresenter: ICategoriesPresenter {
    
    func viewDidLoad() {
        loadCategories()
    }
    
    func didSelectCell(indexPath: IndexPath, category: Category) {
        let boards = models.first(where: { $0.1 == category })?.0 ?? []
        let board = boards[indexPath.row]
        let viewController = ThreadsViewController(boardID: board.identifier)
        viewController.title = board.name
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didTapAllBoards(category: Category) {
        let boards = models.first(where: { $0.1 == category })?.0 ?? []
        let viewController = BoardsListViewController(boards: boards)
        viewController.title = category.rawValue
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didTap(board: Board) {
        let viewController = ThreadsViewController(boardID: board.identifier)
        viewController.title = board.name
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
}
