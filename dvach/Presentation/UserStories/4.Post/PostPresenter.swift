//
//  PostPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IPostViewPresenter {
    var viewModels: [PostCommentView.Model] { get }
    func viewDidLoad()
}

final class PostViewPresenter {
    
    // Dependencies
    weak var view: PostView?
    private let router: IPostRouter
    private let dvachService = Locator.shared.dvachService()

    // Properties
    var viewModels = [PostCommentView.Model]()

    private let boardIdentifier: String
    private let threadNumber: Int
    private var posts = [Post]()
    
    // MARK: - Initialization
    
    init(router: IPostRouter, board: String, threadNum: Int) {
        self.router = router
        self.boardIdentifier = board
        self.threadNumber = threadNum
    }
    
    // MARK: - Private
    
    private func loadPost() {
        dvachService.loadThreadWithPosts(board: boardIdentifier, threadNum: threadNumber, postNum: nil, location: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.posts = posts
                self.viewModels = posts.enumerated().map(self.createViewModel)
                
                DispatchQueue.main.async {
                    self.view?.updateTable()
                }
            case .failure(_):
                break
                // TODO: - показать ошибку
            }
        }
    }
    
    private func createViewModel(index: Int, post: Post) -> PostCommentView.Model {
        let headerViewModel = PostHeaderView.Model(title: post.name, subtitle: post.num, number: index + 1)
        let imageURLs = post.files.map { $0.path }
        
        let postParser = PostParser(text: post.comment)
        
        return PostCommentView.Model(headerModel: headerViewModel,
                                     date: post.date,
                                     text: postParser.attributedText,
                                     imageURLs: imageURLs,
                                     dvachLinkModels: postParser.dvachLinkModels,
                                     repliedTo: postParser.repliedToPosts)
    }
}

// MARK: - IPostViewPresenter

extension PostViewPresenter: IPostViewPresenter {
    
    func viewDidLoad() {
        loadPost()
    }
}
