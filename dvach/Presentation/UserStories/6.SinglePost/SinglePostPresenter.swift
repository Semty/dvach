//
//  SinglePostPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 16/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol ISinglePostPresenter {
    func viewDidLoad()
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int)
}

final class SinglePostPresenter {
    
    // Dependencies
    weak var view: (SinglePostView & UIViewController)?
    private let actionSheetFactory = PostBottomSheetFactory()

    // Properties
    private let post: Post
    
    // MARK: - Initialization
    
    init(post: Post) {
        self.post = post
    }
    
    // MARK: - Private
    
    private func createModel() -> PostCommentView.Model {
        let headerViewModel = PostHeaderView.Model(title: post.name, subtitle: post.num, number: 1)
        let imageURLs = post.files.map { $0.path }
        let postParser = PostParser(text: post.comment)
        
        return PostCommentView.Model(postNumber: post.num,
                                     headerModel: headerViewModel,
                                     date: post.date,
                                     text: postParser.attributedText,
                                     fileURLs: imageURLs,
                                     dvachLinkModels: postParser.dvachLinkModels,
                                     repliedTo: postParser.repliedToPosts)
    }
}

// MARK: - ISinglePostPresenter

extension SinglePostPresenter: ISinglePostPresenter {
    
    func viewDidLoad() {
        view?.configure(model: createModel())
    }
    
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int) {
        let bottomSheet = actionSheetFactory.createBottomSheet(post: post, threadInfo: nil)
        self.view?.present(bottomSheet, animated: true)
    }
}
