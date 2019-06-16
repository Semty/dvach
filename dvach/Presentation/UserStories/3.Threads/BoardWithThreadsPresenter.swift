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
    func refreshControllDidPull()
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
                    self.view?.dataWasLoaded()
                }
            case .failure:
                DispatchQueue.main.async {
                    self.view?.dataWasNotLoaded()
                }
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
        guard let thread = board?.additionalInfo?.threads[index] else { return }
        let viewController = PostAssembly.assemble(board: boardID, thread: thread.shortInfo)
        view?.present(viewController, animated: true)
    }
    
    func addToFavouritesDidTap() {
        guard let board = board else { return }
        dvachService.addToFavourites(.board(board.shortInfo)) { [weak self] in
            DispatchQueue.main.async {
                self?.view?.updateNavigationBar()
            }
        }
    }
    
    func removeFromFavouritesDidTap() {
        guard let board = board else { return }
        dvachService.removeFromFavourites(.board(board.shortInfo))
        view?.updateNavigationBar()
    }
    
    func refreshControllDidPull() {
        loadBoardWithThreads()
    }
    
    var isFavourite: Bool {
        guard let board = board else { return false }
        return dvachService.isFavourite(.board(board.shortInfo))
    }
}
