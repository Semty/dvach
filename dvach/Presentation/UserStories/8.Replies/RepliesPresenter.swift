//
//  RepliesPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IRepliesPresenter {
    var dataSource: [PostCommentView.Model] { get }
    
    func viewDidLoad()
    func didTapFile(index: Int,
                    postIndex: Int,
                    imageViews: [UIImageView])
    func postCommentView(_ view: PostCommentView, didTapURL url: URL)
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int)
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int)
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int)
}

final class RepliesPresenter {
    
    // Dependencies
    weak var view: RepliesView?
    private let router: IPostRouter
    
    // Properties
    private let postId: String
    private let posts: [Post]
    private let replies: Replies
    private let boardId: String
    private let threadShortInfo: ThreadShortInfo
    
    var dataSource = [PostCommentView.Model]()
    
    // MARK: - Initialization
    
    init(postId: String,
         posts: [Post],
         replies: Replies,
         router: IPostRouter,
         board: String,
         thread: ThreadShortInfo) {
        self.postId = postId
        self.posts = posts
        self.replies = replies
        self.router = router
        self.boardId = board
        self.threadShortInfo = thread
    }
    
    // MARK: - Private
    
    private func createModels() -> [PostCommentView.Model] {
        guard let repliesIds = replies[postId] else { return [] }
        let repliedPosts = posts.filter { repliesIds.contains("\($0.num)") }
        return repliedPosts.map(createPostViewModel)
    }
    
    private func createPostViewModel(post: Post) -> PostCommentView.Model {
        let headerViewModel = PostHeaderView.Model(title: post.name, subtitle: post.num, number: post.rowIndex + 1)
        let imageURLs = post.files.map { $0.thumbnail }
        let postParser = PostParser(text: post.comment)
        let repliesCount = replies["\(post.num)"]?.count ?? 0
        
        return PostCommentView.Model(postNumber: post.num,
                                     headerModel: headerViewModel,
                                     date: post.date,
                                     text: postParser.attributedText,
                                     fileURLs: imageURLs,
                                     numberOfReplies: repliesCount,
                                     isAnswerHidden: false,
                                     isRepliesHidden: false)
    }
}

// MARK: - IRepliesPresenter

extension RepliesPresenter: IRepliesPresenter {
    
    func viewDidLoad() {
        dataSource = createModels()
        view?.updateTable()
    }
    
    func didTapFile(index: Int,
                    postIndex: Int,
                    imageViews: [UIImageView]) {
        let mediaViewerSource = MediaViewerManager.Source(imageViews: imageViews,
                                                          files: posts[postIndex].files,
                                                          imageIndex: index)
        
        router.presentMediaController(source: mediaViewerSource)
    }
    
    func postCommentView(_ view: PostCommentView, didTapURL url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int) {
        router.postCommentView(view, didTapAnswerButton: postNumber)
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int) {
        router.postCommentView(view,
                               didTapAnswersButton: postNumber,
                               posts: posts,
                               replies: replies,
                               board: boardId,
                               thread: threadShortInfo)
    }
    
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int) {
        guard let postIndex = posts.firstIndex(where: { $0.num == postNumber }) else { return }
        let post = posts[postIndex]
        router.postCommentView(view,
                               didTapMoreButton: post,
                               thread: threadShortInfo,
                               boardId: boardId,
                               row: post.rowIndex)
    }
}
