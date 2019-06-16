//
//  FavouritePostsPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 13/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IFavouritePostsPresenter {
    var dataSource: [FavouriteThreadView.Model] { get }
    func viewDidLoad()
    func viewWillAppear()
    func didSelectBoard(index: Int)
}

final class FavouritePostsPresenter {
    
    // Dependencies
    weak var view: (FavouritePostsView & UIViewController)?
    private let dvachService = Locator.shared.dvachService()
    
    // Properties
    var dataSource = [FavouriteThreadView.Model]()
    private var favouritePosts = [Post]()
    
    // MARK: - Private
    
    private func createViewModels(posts: [Post]) -> [FavouriteThreadView.Model] {
        return posts.map {
            FavouriteThreadView.Model(title: $0.subject.parsed2chSubject,
                                      subtitle: $0.comment.parsed2chPost,
                                      iconURL: $0.files.first?.thumbnail)
        }
    }
}

// MARK: - IFavouriteThreadsPresenter

extension FavouritePostsPresenter: IFavouritePostsPresenter {
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        favouritePosts = dvachService.favourites(type: Post.self)
        dataSource = createViewModels(posts: favouritePosts)
        view?.updateTable()
    }
    
    func didSelectBoard(index: Int) {
        guard let post = favouritePosts[safeIndex: index] else { return }
        let vc = SinglePostViewController(post: post)
        view?.present(vc, animated: true)
    }
}
