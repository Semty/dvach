//
//  BoardWithThreadsPresenter.swift
//  dvach
//
//  Created by Ruslan Timchenko on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit
import DeepDiff

protocol IBoardWithThreadsPresenter {
    var dataSource: [BoardWithThreadsPresenter.CellType] { get }
    var isFavourite: Bool { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func userDidAgreeWithNSFWTerms()
    func didSelectCell(index: Int)
    func addToFavouritesDidTap()
    func removeFromFavouritesDidTap()
    func refreshControllDidPull()
}

final class BoardWithThreadsPresenter {
    
    enum CellType: DiffAware {
        case withImage(ThreadWithImageView.Model)
        case withoutImage(ThreadWithoutImageView.Model)
        
        // DiffAware
        typealias DiffId = String
        
        var diffId: String {
            switch self {
            case .withImage(let model):
                return model.id
            case .withoutImage(let model):
                return model.id
            }
        }
        
        private var description: String {
            switch self {
            case .withImage(let model):
                return model.description
            case .withoutImage(let model):
                return model.description
            }
        }
        
        static func compareContent(_ a: BoardWithThreadsPresenter.CellType,
                                   _ b: BoardWithThreadsPresenter.CellType) -> Bool {
            return a.description == b.description
        }
    }
    
    // Dependencies
    weak var view: (BoardWithThreadsView & UIViewController)?
    private let dvachService = Locator.shared.dvachService()
    private let viewModelFactory = BoardWithThreadsViewModelFactory()
    private let appSettingsStorage = Locator.shared.appSettingsStorage()
    
    // Properties
    private let boardID: String
    var dataSource = [BoardWithThreadsPresenter.CellType]()
    private var board: Board?
    private var isBannerWarningWasPresented = false
    
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
                let newDataSource = self.createViewModels(board: board)
                let changes = diff(old: self.dataSource, new: newDataSource)
                
                DispatchQueue.main.async {
                    self.view?.updateUI(changes: changes,
                                        completion: { [weak self] in
                                            self?.dataSource = newDataSource
                    })
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
    
    private var shouldPresentBannerViewWarning: Bool {
        let shouldPresent = appSettingsStorage.isSafeMode && !dvachService.isBoardShown(identifier: boardID) && !isBannerWarningWasPresented
        
        // Для того, чтобы баннер не показался лишни раз при viewWillAppear
        isBannerWarningWasPresented = true
        
        return shouldPresent
    }
}

// MARK: - IBoardWithThreadsPresenter

extension BoardWithThreadsPresenter: IBoardWithThreadsPresenter {
    
    func viewDidLoad() {
        loadBoardWithThreads()
    }
    
    func viewWillAppear() {
        if shouldPresentBannerViewWarning {
            view?.showNSFWBanner()
        }
    }
    
    func userDidAgreeWithNSFWTerms() {
        dvachService.markBoardAsShown(identifier: boardID)
    }
    
    func didSelectCell(index: Int) {
        guard let thread = board?.additionalInfo?.threads[index] else { return }
        let viewController = PostAssembly.assemble(board: boardID, thread: thread.shortInfo)
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func addToFavouritesDidTap() {
        guard let board = board else { return }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        dvachService.addToFavourites(.board(board.shortInfo)) { [weak self] in
            DispatchQueue.main.async {
                self?.view?.updateNavigationBar()
            }
        }
    }
    
    func removeFromFavouritesDidTap() {
        guard let board = board else { return }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
