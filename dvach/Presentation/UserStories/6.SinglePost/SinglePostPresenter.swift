//
//  SinglePostPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 16/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SafariServices

protocol ISinglePostPresenter {
    func viewDidLoad()
    func didTapOpenThread()
    func postCommentView(_ view: PostCommentViewContainer, didTapMoreButton button: UIView, postNumber: String)
    func postCommentView(_ view: PostCommentViewContainer, didTapURL url: URL)
    func didTapFile(index: Int,
                    postIndex: Int,
                    imageViews: [UIImageView])
    var postFilesIsEmpty: Bool { get }
}

final class SinglePostPresenter: NSObject {
    
    // Dependencies
    weak var view: (SinglePostView & UIViewController)?
    private let actionSheetFactory = PostBottomSheetFactory()
    private let dvachService = Locator.shared.dvachService()
    private let mediaViewerManager = MediaViewerManager()
    
    // Properties
    public var postFilesIsEmpty: Bool {
        return post.files.isEmpty
    }
    
    private let post: Post
    
    // MARK: - Initialization
    
    init(post: Post) {
        self.post = post
    }
    
    // MARK: - Private
    
    private func createModel() -> PostCommentViewModel {
        let headerViewModel = PostHeaderView.Model(title: post.name.finishHtmlToNormalString(),
                                                   subtitle: post.number,
                                                   number: post.rowIndex + 1)
        let files = post.files.map { FilePathType(urlPath: $0.thumbnail, type: $0.type) }
        let postParser = PostParser(text: post.comment)
        let id = post.identifier
        
        return PostCommentViewModel(postNumber: post.number,
                                    headerModel: headerViewModel,
                                    date: post.date,
                                    text: postParser.attributedText,
                                    files: files,
                                    numberOfReplies: 0,
                                    isAnswerHidden: true,
                                    isRepliesHidden: true,
                                    id: id)
    }
}

// MARK: - ISinglePostPresenter

extension SinglePostPresenter: ISinglePostPresenter {
    
    func viewDidLoad() {
        view?.configure(model: createModel())
    }
    
    func didTapOpenThread() {
        guard let threadInfo = post.threadInfo, let boardId = threadInfo.boardId else { return }
        let vc = PostAssembly.assemble(board: boardId, thread: threadInfo, postNumber: post.number)
        view?.present(vc.wrappedInNavigation, animated: true)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapMoreButton button: UIView, postNumber: String) {
        let bottomSheet = actionSheetFactory.createBottomSheet(post: post,
                                                               threadInfo: nil,
                                                               descriptionAlert:
            { [weak self] alert in
                if let alert = alert {
                    self?.view?.present(alert, animated: true)
                }},
                                                               successAlert:
            { [weak self] alert in
                if let alert = alert {
                    self?.view?.present(alert, animated: true)
                }
        })
        if UIDevice.current.userInterfaceIdiom == .pad,
            let popoverPresentationController = bottomSheet.popoverPresentationController {
            popoverPresentationController.sourceView = button
            popoverPresentationController.sourceRect = CGRect(x: button.bounds.origin.x,
                                                              y: button.bounds.midY,
                                                              width: 0,
                                                              height: 0)
        }
        self.view?.present(bottomSheet, animated: true)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapURL url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        let safariVC = SFSafariViewController(url: url)
        self.view?.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self.view
    }
    
    func didTapFile(index: Int,
                    postIndex: Int,
                    imageViews: [UIImageView]) {
        let mediaViewerSource = MediaViewerManager.Source(imageViews: imageViews,
                                                          files: post.files,
                                                          imageIndex: index)
        guard let mediaController = mediaViewerManager.mediaViewer(source: mediaViewerSource) else { return }
        view?.present(mediaController, animated: true, completion: nil)
    }
}
