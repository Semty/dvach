//
//  BoardWithThreadsPresenter.swift
//  dvach
//
//  Created by Ruslan Timchenko on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

protocol IBoardWithThreadsPresenter {
    var dataSource: [BoardWithThreadsPresenter.CellType] { get }
    var isFavourite: Bool { get }
    
    func viewDidLoad()
    func didSelectCell(index: Int)
    func addToFavouritesDidTap()
    func removeFromFavouritesDidTap()
}

final class BoardWithThreadsPresenter {
    
    enum CellType {
        case withImage(ThreadWithImageView.Model)
        case withoutImage(ThreadWithoutImageView.Model)
    }
    
    // Dependencies
    weak var view: (BoardWithThreadsView & UIViewController)?
    private let dvachService = Locator.shared.dvachService()
    private let viewModelFactory = ThreadsViewModelFactory()
    
    // Properties
    private let boardID: String
    var dataSource = [BoardWithThreadsPresenter.CellType]()
    private var board: Board?
    
    // MARK: - Initialization
    
    init(boardID: String) {
        self.boardID = boardID
    }
    
    // MARK: - Private
    
    private func loadBoardWithThreads() {
        dvachService.loadBoardWithBumpSortingThreadsCatalog(boardID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let board):
                self.board = board
                self.dataSource = self.createViewModels(board: board)
                
                DispatchQueue.main.async {
                    self.view?.updateTable()
                }
            case .failure:
                break
            }
        }
    }
    
    private func createViewModels(board: Board) -> [CellType] {
        guard let threads = board.additionalInfo?.threads else { return [] }
        return viewModelFactory.createThreadsViewModels(threads: threads)
    }
}

// MARK: - IBoardWithThreadsPresenter

extension BoardWithThreadsPresenter: IBoardWithThreadsPresenter {
    
    func viewDidLoad() {
        loadBoardWithThreads()
    }
    
    func didSelectCell(index: Int) {
        guard let threadNumber = board?.additionalInfo?.threads[index].num else { return }
        
        let viewController = PostAssembly.assemble(board: boardID, threadNum: threadNumber)
        view?.present(viewController, animated: true)
    }
    
    func addToFavouritesDidTap() {
        guard let board = board else { return }
        dvachService.addBoardToFavourites(board) { [weak self] in
            DispatchQueue.main.async {
                self?.view?.updateNavigationBar()
            }
        }
    }
    
    func removeFromFavouritesDidTap() {
        guard let board = board else { return }
        dvachService.removeBoardFromFavourites(board)
        view?.updateNavigationBar()
    }
    
    var isFavourite: Bool {
        return dvachService.isBoardFavourite(identifier: boardID)
    }
}
