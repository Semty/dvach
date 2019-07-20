//
//  SinglePostPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 16/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Appodeal
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
    private lazy var adManager: IAdManager = {
        let manager = Locator.shared.createAdManager(numberOfNativeAds: 1,
                                                     viewController: view)
        manager.delegate = self
        return manager
    }()
    
    // Properties
    public var postFilesIsEmpty: Bool {
        return post.files.isEmpty
    }
    
    private let post: Post
    private lazy var adQueue = APDNativeAdQueue()
    private var queueLoaded = false
    
    // MARK: - Initialization
    
    init(post: Post) {
        self.post = post
    }
    
    // MARK: - Private
    
    private func createModel() -> PostCommentViewModel {
        let headerViewModel = PostHeaderView.Model(title: post.name,
                                                   subtitle: post.number,
                                                   number: post.rowIndex + 1)
        let imageURLs = post.files.map { $0.thumbnail }
        let postParser = PostParser(text: post.comment)
        
        return PostCommentViewModel(postNumber: post.number,
                                    headerModel: headerViewModel,
                                    date: post.date,
                                    text: postParser.attributedText,
                                    fileURLs: imageURLs,
                                    numberOfReplies: 0,
                                    isAnswerHidden: true,
                                    isRepliesHidden: true)
    }
}

// MARK: - ISinglePostPresenter

extension SinglePostPresenter: ISinglePostPresenter {
    
    func viewDidLoad() {
        adManager.loadNativeAd()
        view?.configure(model: createModel())
    }
    
    func didTapOpenThread() {
        guard let threadInfo = post.threadInfo, let boardId = threadInfo.boardId else { return }
        let vc = PostAssembly.assemble(board: boardId, thread: threadInfo, postNumber: post.number)
        Analytics.logEvent("OpenThreadButtonTapped", parameters: [:])
        view?.present(vc.wrappedInNavigation, animated: true)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapMoreButton button: UIView, postNumber: String) {
        let bottomSheet = actionSheetFactory.createBottomSheet(post: post, threadInfo: nil)
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

// MARK: - AdManagerDelegate

extension SinglePostPresenter: AdManagerDelegate {
    
    func adManagerDidCreateNativeAdView(_ view: AdView) {
        self.view?.addAdvertisingView(view)
    }
}
