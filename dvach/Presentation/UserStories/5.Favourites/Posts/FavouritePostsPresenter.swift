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
    private let appSettingsStorage = Locator.shared.appSettingsStorage()
    private let profanityCensor = Locator.shared.profanityCensor()
    
    // Properties
    var dataSource = [FavouriteThreadView.Model]()
    private var favouritePosts = [Post]()
    
    // MARK: - Private
    
    private func createViewModels(posts: [Post]) -> [FavouriteThreadView.Model] {
        let isSafeMode = appSettingsStorage.isSafeMode
        return posts.map { post in
            let censorSubject = isSafeMode ? profanityCensor
                .censor(post.subject.parsed2chSubject,
                        symbol: "*") : post.subject.parsed2chSubject
            let censorPost = isSafeMode ? profanityCensor
                .censor(post.comment.parsed2chPost,
                        symbol: "*") : post.comment.parsed2chPost
            return FavouriteThreadView.Model(title: censorSubject,
                                             subtitle: censorPost,
                                             iconURL: post.files.first?.thumbnail)
        }
    }
}

// MARK: - IFavouriteThreadsPresenter

extension FavouritePostsPresenter: IFavouritePostsPresenter {
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        let newFavouritePosts = dvachService.favourites(type: Post.self)
        if favouritePosts.count != newFavouritePosts.count {
            favouritePosts = dvachService.favourites(type: Post.self)
            dataSource = createViewModels(posts: favouritePosts)
            view?.updateTable()
        }
    }
    
    func didSelectBoard(index: Int) {
        guard let post = favouritePosts[safeIndex: index] else { return }
        let vc = SinglePostViewController(post: post)
        view?.present(vc, animated: true)
    }
}
