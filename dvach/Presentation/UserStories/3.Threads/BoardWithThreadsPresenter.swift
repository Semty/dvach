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
    var currentPage: Int? { get }
    var lastPage: Int? { get }
    var isLoadingNewData: Bool { get }
    var isFavourite: Bool { get }
    
    func viewDidLoad()
    func didSelectCell(index: Int)
    func addToFavouritesDidTap()
    func removeFromFavouritesDidTap()
    func loadBoardWithThreads(page: Int)
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
    
    // Public Properties and Flags
    public var dataSource = [BoardWithThreadsPresenter.CellType]()
    public var currentPage: Int? {
        return board?.currentPage
    }
    public var lastPage: Int? {
        guard let pages = board?.pages else { return nil }
        return pages - 1
    }
    public var isLoadingNewData = false
    
    // Private Properties
    private let boardID: String
    private var board: Board?
    
    // MARK: - Initialization
    
    init(boardID: String) {
        self.boardID = boardID
    }
    
    // MARK: - Public Functions
    
    public func loadBoardWithThreads(page: Int) {
        isLoadingNewData = true
        dvachService.loadBoardWithPerPageThreadsRequest(boardID, page) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingNewData = false
            
            switch result {
            case .success(let board):
                self.board = board
                
                if page == 0 {
                    self.dataSource = self.createViewModels(board: board)
                } else {
                    self.dataSource += self.createViewModels(board: board)
                }
                
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
        loadBoardWithThreads(page: 0)
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
