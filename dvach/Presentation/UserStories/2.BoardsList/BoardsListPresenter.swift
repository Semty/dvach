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
}

final class BoardsListPresenter {
    
    // Dependencies
    weak var view: (BoardsListView & UIViewController)?
    
    // Properties
    private let boards: [Board]
    var dataSource = [BoardView.Model]()
    
    // MARK: - Initialization
    
    init(boards: [Board]) {
        self.boards = boards
    }
    
    // MARK: - Private
    
    private func createViewModels() -> [BoardView.Model] {
        let icon: UIImage
        if let assetsIcon = UIImage(named: "anime") {
            icon = assetsIcon
        } else {
            icon = UIImage()
        }
        
        return boards.map { BoardView.Model(title: $0.name,
                                            subtitle: "\\\($0.identifier)\\",
                                            icon: icon) }
    }
}

// MARK: - IBoardsListPresenter

extension BoardsListPresenter: IBoardsListPresenter {
    
    func viewDidLoad() {
        dataSource = createViewModels()
        view?.updateTable()
    }
    
    func didSelectBoard(index: Int) {
        let board = boards[index]
        let viewController = ThreadsViewController(boardID: board.identifier)
        viewController.title = board.name
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
}
