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
}

final class FavouriteBoardsPresenter {
    
    // Dependencies
    weak var view: (FavouriteBoardsView & UIViewController)?
    private let dvachService = Locator.shared.dvachService()
    
    // Properties
    var dataSource = [BoardView.Model]()
    private var favouriteBoards = [FavouriteBoard]()
    
    // MARK: - Private
    
    private func createViewModels(boards: [FavouriteBoard]) -> [BoardView.Model] {
        return boards.map {
            BoardView.Model(title: $0.name,
                            subtitle: "/\($0.identifier)/",
                            icon: .icon(boardId: $0.identifier))
            
        }
    }
}

// MARK: - IFavouriteBoardsPresenter

extension FavouriteBoardsPresenter: IFavouriteBoardsPresenter {
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        favouriteBoards = dvachService.favouriteBoards
        dataSource = createViewModels(boards: favouriteBoards)
        view?.updateTable()
    }
    
    func didSelectBoard(index: Int) {
        guard let board = favouriteBoards[safeIndex: index] else { return }
        let viewController = ThreadsViewController(boardID: board.identifier)
        viewController.title = board.name
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
}
