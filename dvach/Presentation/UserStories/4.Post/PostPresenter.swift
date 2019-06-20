//
//  PostPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IPostViewPresenter {
    var files: [File] { get }
    var posts: [Post] { get }
    var viewModels: [PostCommentView.Model] { get }
    
    func viewDidLoad()
    func postCommentView(_ view: PostCommentView, didTapFile index: Int,
                         post: Int, imageView: UIImageView)
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
    private let thread: ThreadShortInfo
    private var scrollTo: Int
    
    public var files = [File]()
    public var posts = [Post]()
    
    // MARK: - Initialization
    
    init(router: IPostRouter, board: String, thread: ThreadShortInfo, scrollTo: Int) {
        self.router = router
        self.boardIdentifier = board
        self.thread = thread
        self.scrollTo = scrollTo
    }
    
    // MARK: - Private
    
    private func loadPost() {
        dvachService.loadThreadWithPosts(board: boardIdentifier,
                                         threadNum: thread.number,
                                         postNum: nil,
                                         location: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.posts = posts
                self.files = []
                self.viewModels = posts.enumerated().map(self.createViewModel)
                
                DispatchQueue.main.async {
                    self.view?.updateTable(scrollTo: self.scrollTo)
                }
            case .failure(_):
                break
                // TODO: - показать ошибку
            }
        }
    }
    
    private func createViewModel(index: Int, post: Post) -> PostCommentView.Model {
        let headerViewModel = PostHeaderView.Model(title: post.name, subtitle: post.num, number: index + 1)
        let imageURLs = post.files.map { $0.thumbnail }
        post.files.forEach { self.files.append($0) }
        let postParser = PostParser(text: post.comment)
        
        return PostCommentView.Model(postNumber: post.num,
                                     headerModel: headerViewModel,
                                     date: post.date,
                                     text: postParser.attributedText,
                                     fileURLs: imageURLs,
                                     dvachLinkModels: postParser.dvachLinkModels,
                                     repliedTo: postParser.repliedToPosts,
                                     isAnswerHidden: false,
                                     isRepliesHidden: false)
    }
}

// MARK: - IPostViewPresenter

extension PostViewPresenter: IPostViewPresenter {
    
    func viewDidLoad() {
        loadPost()
    }
    
    func postCommentView(_ view: PostCommentView, didTapFile index: Int,
                         post: Int, imageView: UIImageView) {
        
        let mediaPresenter = MediaViewerPresenter()
        let mediaViewer = MediaViewerController(mediaPresenter,
                                                imageView,
                                                imageView.image)
        
        //router.postCommentView(view, didTapFile: index)
        self.view?.presentMediaController(vc: mediaViewer)
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int) {
        router.postCommentView(view, didTapAnswerButton: postNumber)
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int) {
        router.postCommentView(view, didTapAnswersButton: postNumber)
    }
    
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int) {
        guard let postIndex = posts.firstIndex(where: { $0.num == postNumber }) else { return }
        let post = posts[postIndex]
        router.postCommentView(view, didTapMoreButton: post, thread: thread, boardId: boardIdentifier, row: postIndex)
    }
}
