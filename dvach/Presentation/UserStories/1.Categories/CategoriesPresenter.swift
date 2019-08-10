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
    func didTapUpdate()
}

final class CategoriesPresenter {
    
    // Nested
    struct DataSource: Equatable {
        var boards: [Board]
        let category: Category
        
        static func == (lhs: CategoriesPresenter.DataSource, rhs: CategoriesPresenter.DataSource) -> Bool {
            return lhs.category == rhs.category
        }
    }
    
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
                DispatchQueue.main.async {
                    self?.view?.showPlaceholder(text: error.localizedDescription)
                }
            }
        }
    }
    
    private func createViewModels(boards: [Board]) -> [BlockModel] {
        var japan = DataSource(boards: [], category: .japan)
        var games = DataSource(boards: [], category: .games)
        var politics = DataSource(boards: [], category: .politics)
        var other = DataSource(boards: [], category: .other)
        var art = DataSource(boards: [], category: .art)
        var theme = DataSource(boards: [], category: .theme)
        var technics = DataSource(boards: [], category: .technics)
        var user = DataSource(boards: [], category: .user)
        var adults = DataSource(boards: [], category: .adults)
        var hidden = DataSource(boards: [], category: .hidden)
        
        boards.forEach {
            switch $0.shortInfo.category {
            case .japan: japan.boards.append($0)
            case .games: games.boards.append($0)
            case .politics: politics.boards.append($0)
            case .user : user.boards.append($0)
            case .other:
                // TODO: дискуссии и абу временно удалены
                if !($0.shortInfo.identifier == "d" || $0.shortInfo.identifier == "abu") {
                    other.boards.append($0)
                }
            case .art: art.boards.append($0)
            case .theme: theme.boards.append($0)
            case .technics: technics.boards.append($0)
            case .adults: adults.boards.append($0)
            case .hidden: hidden.boards.append($0)
            }
        }
        
        // По сути дефолтный порядок
        var categories = [other, theme, art, technics, games, politics, japan, user, hidden, adults]
        
        // Тут выставляется порядок блоков из конфига, если он есть
        if let order = Config.blocksOrder {
            models = order.compactMap { category in
                categories.first(where: { $0.category == category })
            }
        } else {
            categories.removeObject(hidden) // кроме "Скрытые"
            categories.removeObject(adults) // кроме "Взрослым"
            models = categories
        }
        
        return models.compactMap { viewModelsFactory.createViewModels(category: $0.category, boards: $0.boards) }
    }
}

// MARK: - ICategoriesPresenter

extension CategoriesPresenter: ICategoriesPresenter {
    
    func viewDidLoad() {
        loadCategories()
        Analytics.logEvent("CategoriesShown", parameters: [:])
    }
    
    func didSelectCell(indexPath: IndexPath, category: Category) {
        let boards = models.first(where: { $0.category == category })?.boards ?? []
        let board = boards[indexPath.row]
        let viewController = BoardWithThreadsViewController(boardID: board.shortInfo.identifier)
        viewController.title = board.shortInfo.name
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didTapAllBoards(category: Category) {
        let boards = models.first(where: { $0.category == category })?.boards ?? []
        let viewController = BoardsListViewController(boards: boards)
        viewController.title = category.rawValue
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didTap(board: Board) {
        let viewController = BoardWithThreadsViewController(boardID: board.shortInfo.identifier)
        viewController.title = board.shortInfo.name
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didTapUpdate() {
        loadCategories()
        Analytics.logEvent("UpdateBoardsTapped", parameters: [:])
    }
}
