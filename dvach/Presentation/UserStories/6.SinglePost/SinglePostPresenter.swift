//
//  SinglePostPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 16/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Appodeal

protocol ISinglePostPresenter {
    func viewDidLoad()
    func didTapOpenThread()
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int)
    func didTapFile(index: Int,
                    postIndex: Int,
                    imageViews: [UIImageView])
}

final class SinglePostPresenter: NSObject {
    
    // Dependencies
    weak var view: (SinglePostView & UIViewController)?
    private let actionSheetFactory = PostBottomSheetFactory()
    private let dvachService = Locator.shared.dvachService()
    private let mediaViewerManager = MediaViewerManager()
    private lazy var adManager: IAdManager = {
        let manager = Locator.shared.createAdManager(viewController: view)
        manager.delegate = self
        return manager
    }()
    
    // Properties
    private let post: Post
    private lazy var adQueue = APDNativeAdQueue()
    private var queueLoaded = false
    
    // MARK: - Initialization
    
    init(post: Post) {
        self.post = post
    }
    
    // MARK: - Private
    
    private func createModel(adView: (UIView & APDNativeAdView)?) -> PostCommentView.Model {
        let headerViewModel = PostHeaderView.Model(title: post.name,
                                                   subtitle: post.num,
                                                   number: post.rowIndex + 1)
        let imageURLs = post.files.map { $0.thumbnail }
        let postParser = PostParser(text: post.comment)
        
        return PostCommentView.Model(postNumber: post.num,
                                     headerModel: headerViewModel,
                                     date: post.date,
                                     text: postParser.attributedText,
                                     fileURLs: imageURLs,
                                     dvachLinkModels: postParser.dvachLinkModels,
                                     repliedTo: postParser.repliedToPosts,
                                     isAnswerHidden: true,
                                     isRepliesHidden: true,
                                     adView: adView)
    }
}

// MARK: - ISinglePostPresenter

extension SinglePostPresenter: ISinglePostPresenter {
    
    func viewDidLoad() {
        adManager.loadNativeAd()
        view?.configure(model: createModel(adView: nil))
    }
    
    func didTapOpenThread() {
        guard let threadInfo = post.threadInfo, let boardId = threadInfo.boardId else { return }
        let vc = PostAssembly.assemble(board: boardId, thread: threadInfo, scrollTo: post.rowIndex)
        view?.present(vc, animated: true)
    }
    
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int) {
        let bottomSheet = actionSheetFactory.createBottomSheet(post: post, threadInfo: nil)
        self.view?.present(bottomSheet, animated: true)
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
    
    func adManagerDidCreateNativeAdViews(_ views: [(UIView & APDNativeAdView)]) {
        view?.configure(model: createModel(adView: views.first))
    }
}
