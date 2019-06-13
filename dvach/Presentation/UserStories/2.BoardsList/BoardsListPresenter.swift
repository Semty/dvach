//
//  BoardsListPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 04/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IBoardsListPresenter {
    var dataSource: [BoardView.Model] { get }
    func viewDidLoad()
    func didSelectBoard(index: Int)
    func searchBoard(for text: String?)
}

final class BoardsListPresenter {
    
    // Dependencies
    weak var view: (BoardsListView & UIViewController)?
    
    // Properties
    private let boards: [Board]
    private var filteredBoards = [Board]()
    var dataSource = [BoardView.Model]()
    
    // MARK: - Initialization
    
    init(boards: [Board]) {
        self.boards = boards
    }
    
    // MARK: - Private
    
    private func createViewModels(from boards: [Board]) -> [BoardView.Model] {
        return boards.map {
            return BoardView.Model(title: $0.name,
                                            subtitle: "/\($0.identifier)/",
                                            icon: .icon(boardId: $0.identifier)) }
    }
}

// MARK: - IBoardsListPresenter

extension BoardsListPresenter: IBoardsListPresenter {
    
    func viewDidLoad() {
        dataSource = createViewModels(from: boards)
        view?.updateTable()
    }
    
    func didSelectBoard(index: Int) {
        let board = filteredBoards.isEmpty ? boards[index] : filteredBoards[index]
        view?.didSelectBoard(board)
        
        let viewController = ThreadsViewController(boardID: board.identifier)
        viewController.title = board.name
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func searchBoard(for text: String?) {
        guard let text = text, !text.isEmpty else { return }
        filteredBoards = boards.filter {
            $0.name.lowercased().contains(text) || $0.identifier.lowercased().contains(text)
        }
        let viewModels = createViewModels(from: filteredBoards)
        dataSource = viewModels
        view?.updateTable()
    }
}
