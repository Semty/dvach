//
//  FavouriteBoardsPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 13/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IFavouriteBoardsPresenter {
    var dataSource: [BoardView.Model] { get }
    func viewDidLoad()
    func viewWillAppear()
    func didSelectBoard(index: Int)
    func didRemoveBoard(index: Int)
}

final class FavouriteBoardsPresenter {
    
    // Dependencies
    weak var view: (FavouriteBoardsView & UIViewController)?
    private let dvachService = Locator.shared.dvachService()
    
    // Properties
    var dataSource = [BoardView.Model]()
    private var favouriteBoards = [BoardShortInfo]()
    
    // MARK: - Private
    
    private func createViewModels(boards: [BoardShortInfo]) -> [BoardView.Model] {
        return boards.map {
            BoardView.Model(title: $0.name,
                            subtitle: "/\($0.identifier)/",
                            icon: .icon(boardId: $0.identifier))
            
        }
    }
    
    private func updateDataSourceIfNeeded() {
        favouriteBoards = dvachService.favourites(type: BoardShortInfo.self)
        dataSource = createViewModels(boards: favouriteBoards)
        view?.updateTable()
    }
}

// MARK: - IFavouriteBoardsPresenter

extension FavouriteBoardsPresenter: IFavouriteBoardsPresenter {
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        updateDataSourceIfNeeded()
    }
    
    func didSelectBoard(index: Int) {
        guard let board = favouriteBoards[safeIndex: index] else { return }
        let viewController = BoardWithThreadsViewController(boardID: board.identifier)
        viewController.title = board.name
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didRemoveBoard(index: Int) {
        guard let board = favouriteBoards[safeIndex: index] else { return }
        dvachService.removeFromFavourites(.board(board))
        updateDataSourceIfNeeded()
    }
}
