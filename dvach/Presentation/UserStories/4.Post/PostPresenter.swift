//
//  PostPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Appodeal

protocol IPostViewPresenter {
    var viewModels: [PostCommentView.Model] { get }
    
    func viewDidLoad()
    func didTapFile(index: Int,
                    postIndex: Int,
                    imageViews: [UIImageView])
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int)
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int)
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int)
}

final class PostViewPresenter {
    
    // Dependencies
    weak var view: (PostView & UIViewController)?
    private let router: IPostRouter
    private let dvachService = Locator.shared.dvachService()
    private lazy var adManager: IAdManager = {
        let manager = Locator.shared.createAdManager(viewController: view)
        manager.delegate = self
        return manager
    }()
    
    // Properties
    var viewModels = [PostCommentView.Model]()

    private let boardIdentifier: String
    private let thread: ThreadShortInfo
    private var scrollTo: Int // Post
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
                self.viewModels = posts.enumerated().map { index, item in
                    self.createViewModel(index: index, post: item, adView: nil)
                }
                
                DispatchQueue.main.async {
                    self.view?.updateTable(scrollTo: self.scrollTo)
                }
            case .failure(_):
                break
                // TODO: - показать ошибку
            }
        }
    }
    
    private func createViewModel(index: Int, post: Post, adView: AdView?) -> PostCommentView.Model {
        let headerViewModel = PostHeaderView.Model(title: post.name, subtitle: post.num, number: index + 1)
        let imageURLs = post.files.map { $0.thumbnail }
        let postParser = PostParser(text: post.comment)
        
        return PostCommentView.Model(postNumber: post.num,
                                     headerModel: headerViewModel,
                                     date: post.date,
                                     text: postParser.attributedText,
                                     fileURLs: imageURLs,
                                     dvachLinkModels: postParser.dvachLinkModels,
                                     repliedTo: postParser.repliedToPosts,
                                     isAnswerHidden: false,
                                     isRepliesHidden: false,
                                     adView: adView)
    }
}

// MARK: - IPostViewPresenter

extension PostViewPresenter: IPostViewPresenter {
    
    func viewDidLoad() {
        loadPost()
//        adManager.loadNativeAd()
    }
    
    func didTapFile(index: Int,
                    postIndex: Int,
                    imageViews: [UIImageView]) {
        let mediaViewerSource = MediaViewerManager.Source(imageViews: imageViews,
                                                          files: posts[postIndex].files,
                                                          imageIndex: index)

        router.presentMediaController(source: mediaViewerSource)
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

// MARK: - AdManagerDelegate

extension PostViewPresenter: AdManagerDelegate {
    
    func adManagerDidCreateNativeAdViews(_ views: [AdView]) {
        DispatchQueue.global().async {
            self.viewModels = self.posts.enumerated().map { index, item in
                let adView = views[safeIndex: index]
                print(adView)
                return self.createViewModel(index: index, post: item, adView: adView)
            }
            
            DispatchQueue.main.async {
                self.view?.updateTable(scrollTo: self.scrollTo)
            }
        }
    }
}
