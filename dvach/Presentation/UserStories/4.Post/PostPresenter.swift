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
    var dataSource: [PostViewPresenter.CellType] { get }
    
    func viewDidLoad()
    func refresh()
    func didTapFile(index: Int,
                    postIndex: Int,
                    imageViews: [UIImageView])
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int)
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int)
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int)
}

final class PostViewPresenter {
    
    enum CellType {
        case post(PostCommentView.Model)
        case ad(ContextAddView)
        
        var postNumber: Int? {
            switch self {
            case .post(let model):
                return model.postNumber
            default:
                return nil
            }
        }
    }
    
    // Dependencies
    weak var view: (PostView & UIViewController)?
    private let router: IPostRouter
    private let dvachService = Locator.shared.dvachService()
    private lazy var adManager: IAdManager = {
        let manager = Locator.shared.createAdManager(numberOfNativeAds: 10, viewController: view)
        manager.delegate = self
        return manager
    }()
    
    // Properties
    var dataSource = [CellType]()

    private let boardIdentifier: String
    private let thread: ThreadShortInfo
    private var postNumber: Int?
    private var posts = [Post]()
    
    // MARK: - Initialization
    
    init(router: IPostRouter, board: String, thread: ThreadShortInfo, postNumber: Int?) {
        self.router = router
        self.boardIdentifier = board
        self.thread = thread
        self.postNumber = postNumber
    }
    
    // MARK: - Private
    
    private func loadPost(completion: @escaping (Error?) -> Void) {
        dvachService.loadThreadWithPosts(board: boardIdentifier,
                                         threadNum: thread.number,
                                         postNum: nil,
                                         location: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                var enrichedPosts = [Post]()
                let dataSource: [CellType] = posts.enumerated().map { index, item in
                    var post = item
                    post.rowIndex = index // Проставляем индекс здесь, чтобы он не сбился из-за рекламы
                    enrichedPosts.append(post)
                    let model = self.createPostViewModel(post: post)
                    return .post(model)
                }
                self.posts = enrichedPosts
                self.dataSource = dataSource
                
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private func createPostViewModel(post: Post) -> PostCommentView.Model {
        let headerViewModel = PostHeaderView.Model(title: post.name, subtitle: post.num, number: post.rowIndex + 1)
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
                                     isRepliesHidden: false)
    }
    
    private func scrollIndexPath(for dataSource: [CellType]) -> IndexPath? {
        guard let postNumber = postNumber else { return nil }
        var row = 0
        dataSource.enumerated().forEach {
            if $0.element.postNumber == postNumber {
                row = $0.offset
                return
            }
        }
 
        return IndexPath(row: row, section: 0)
    }
}

// MARK: - IPostViewPresenter

extension PostViewPresenter: IPostViewPresenter {
    
    func viewDidLoad() {
        loadPost { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    self.view?.showPlaceholder(text: error.localizedDescription)
                }
            } else {
                let scrollIndexPath = self.scrollIndexPath(for: self.dataSource)
                DispatchQueue.main.async {
                    self.view?.updateTable(scrollTo: scrollIndexPath)
                }
                self.adManager.loadNativeAd()
            }
        }
    }
    
    func refresh() {
        postNumber = posts.last?.num

        loadPost { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let scrollIndexPath = self.scrollIndexPath(for: self.dataSource)
                self.view?.endRefreshing(indexPath: scrollIndexPath)
            }
        }
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
        router.postCommentView(view,
                               didTapMoreButton: post,
                               thread: thread,
                               boardId: boardIdentifier,
                               row: post.rowIndex)
    }
}

// MARK: - AdManagerDelegate

extension PostViewPresenter: AdManagerDelegate {
    
    func adManagerDidCreateNativeAdViews(_ views: [AdView]) {
        var ads: [CellType] = views.compactMap {
            guard let adView = $0 as? ContextAddView else { return nil }
            return CellType.ad(adView)
        }
        var newDataSource = dataSource
        dataSource.enumerated().forEach { index, item in
            if index != 0, index % .adPeriod == 0, let ad = ads.first {
                ads = Array(ads.dropFirst())
                newDataSource.insert(ad, at: index)
            }
        }
        let scrollIndexPath = self.scrollIndexPath(for: newDataSource)
        
        DispatchQueue.main.async {
            self.dataSource = newDataSource
            self.view?.updateTable(scrollTo: scrollIndexPath)
        }
    }
}
