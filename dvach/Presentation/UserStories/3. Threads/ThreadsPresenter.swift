//
//  ThreadsPresenter.swift
//  dvach
//
//  Created by Ruslan Timchenko on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

protocol IThreadsPresenter: NSFWDelegate {
    var dataSource: [ThreadsPresenter.CellType] { get }
    var nsfwData: [String: (isNSFW: String, confidence: Double)] { get set }
    func viewDidLoad()
}

final class ThreadsPresenter {
    enum CellType {
        case withImage(ThreadWithImageView.Model)
        case withoutImage(ThreadWithoutImageView.Model)
    }
    
    // Dependencies
    weak var view: BoardWithThreadsView?
    private let dvachService = Locator.shared.dvachService()
    private let viewModelFactory = ThreadsViewModelFactory()
    
    // Properties
    private let boardID: String
    var dataSource = [ThreadsPresenter.CellType]()
    
    // NSFW Dictionary
    public var nsfwData = [String: (isNSFW: String, confidence: Double)]()
    
    // MARK: - Initialization
    
    init(boardID: String) {
        self.boardID = boardID
    }
    
    // MARK: - Private
    private func loadBoardWithBumpSortingThreads() {
        dvachService.loadBoardWithBumpSortingThreads(boardID) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let board):
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
        var viewModels = [CellType]()
        guard let threads = board.additionalInfo?.threads else { return [] }
        
        viewModels = viewModelFactory.createThreadsViewModels(threads: threads)
        
        return viewModels
    }
}

// MARK: - IThreadsPresenter

extension ThreadsPresenter: IThreadsPresenter {
    func viewDidLoad() {
        loadBoardWithBumpSortingThreads()
    }
}
