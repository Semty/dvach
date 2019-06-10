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
    func postCommentView(_ view: PostCommentView, didTapFile index: Int)
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int)
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int)
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int)
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
        return PostCommentView.Model(postNumber: post.num,
                                     headerModel: headerViewModel,
                                     date: post.date,
                                     text: PostParse(text: post.comment).attributedText,
                                     fileURLs: imageURLs)
    }
}

// MARK: - IPostViewPresenter

extension PostViewPresenter: IPostViewPresenter {
    
    func viewDidLoad() {
        loadPost()
    }
    
    func postCommentView(_ view: PostCommentView, didTapFile index: Int) {
        router.postCommentView(view, didTapFile: index)
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int) {
        router.postCommentView(view, didTapAnswerButton: postNumber)
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int) {
        router.postCommentView(view, didTapAnswersButton: postNumber)
    }
    
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int) {
        router.postCommentView(view, didTapMoreButton: postNumber)
    }
}
