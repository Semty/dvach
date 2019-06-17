//
//  FavouriteThreadsPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 13/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IFavouriteThreadsPresenter {
    var dataSource: [FavouriteThreadView.Model] { get }
    func viewDidLoad()
    func viewWillAppear()
    func didSelectBoard(index: Int)
}

final class FavouriteThreadsPresenter {
    
    // Dependencies
    weak var view: (FavouriteThreadsView & UIViewController)?
    private let dvachService = Locator.shared.dvachService()
    
    // Properties
    var dataSource = [FavouriteThreadView.Model]()
    private var favouriteThreads = [ThreadShortInfo]()
    
    // MARK: - Private
    
    private func createViewModels(threads: [ThreadShortInfo]) -> [FavouriteThreadView.Model] {
        return threads.map {
            FavouriteThreadView.Model(title: $0.subject,
                                      subtitle: $0.comment,
                                      iconURL: $0.thumbnailURL)
        }
    }
}

// MARK: - IFavouriteThreadsPresenter

extension FavouriteThreadsPresenter: IFavouriteThreadsPresenter {
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        favouriteThreads = dvachService.favourites(type: ThreadShortInfo.self).filter { $0.isFavourite }
        dataSource = createViewModels(threads: favouriteThreads)
        view?.updateTable()
    }
    
    func didSelectBoard(index: Int) {
        guard let thread = favouriteThreads[safeIndex: index],
            let boardId = thread.boardId else { return }
        
        let viewController = PostAssembly.assemble(board: boardId, thread: thread)
        view?.present(viewController, animated: true)
    }
}
