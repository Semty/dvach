//
//  PostPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import FLAnimatedImage

protocol IPostViewPresenter {
    var posts: [Post] { get }
    var viewModels: [PostCommentView.Model] { get }
    
    func viewDidLoad()
    func postCommentView(_ view: PostCommentView, didTapFile index: Int,
                         post: Int, imageView: UIImageView, imageViews: [UIImageView])
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
    
    private var scrollTo: Int // Post
    
    private var activeImageViews = [UIImageView]()
    private var activeImageIndex = 0
    private var activeFiles = [File]()
    
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
                         post: Int, imageView: UIImageView, imageViews: [UIImageView]) {
        
        activeImageViews = imageViews
        activeImageIndex = index
        activeFiles = posts[post].files
        
        let mediaPresenter = MediaViewerPresenter()
        let mediaViewer = MediaViewerController(mediaPresenter,
                                                imageView,
                                                imageView.image)
        
        mediaViewer.dataSource = self
        mediaViewer.delegate = self
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

// MARK: - DTMediaViewerControllerDataSource

extension PostViewPresenter: DTMediaViewerControllerDataSource {
    
    func photoViewerController(_ photoViewerController: DTMediaViewerController,
                               referencedViewForPhotoAt index: Int) -> UIView? {
        return activeImageViews[safeIndex: index]
    }
    
    func numberOfItems(in photoViewerController: DTMediaViewerController) -> Int {
        return activeImageViews.count
    }
    
    func photoViewerController(_ photoViewerController: DTMediaViewerController,
                               configurePhotoAt index: Int,
                               withImageView imageView: FLAnimatedImageView) {
        let file = activeFiles[index]
        let thumbnailImage = activeImageViews[safeIndex: index]?.image
        if file.type == .gif
            || file.type == .jpg
            || file.type == .png
            || file.type == .sticker {
            ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
            imageView.loadImage(url: file.path,
                                defaultImage: thumbnailImage,
                                placeholder: thumbnailImage,
                                transition: false)
        } else {
            imageView.image = thumbnailImage
        }
    }
}

// MARK: - DTMediaViewerControllerDelegate

extension PostViewPresenter: DTMediaViewerControllerDelegate {
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTMediaViewerController) {
        photoViewerController.scrollToPhoto(at: activeImageIndex, animated: false)
    }
    
    func photoViewerController(_ photoViewerController: DTMediaViewerController, didScrollToPhotoAt index: Int) {
        activeImageIndex = index
    }
}
