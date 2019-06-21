//
//  PostRouter.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IPostRouter {
    
    /// Нажали на миниатюру прикрепленого файла
    func postCommentView(_ view: PostCommentView, didTapFile index: Int)
    
    /// Нажали на "Ответить"
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int)
    
    /// Нажали на "Ответы"
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int)
    
    /// Нажали на "Еще"
    func postCommentView(_ view: PostCommentView,
                         didTapMoreButton post: Post,
                         thread: ThreadShortInfo,
                         boardId: String,
                         row: Int)
    
    func presentMediaController(source: MediaViewerManager.Source)
}

final class PostRouter: IPostRouter {
    
    // Dependencies
    weak var viewHandler: UIViewController?
    private let actionSheetFactory = PostBottomSheetFactory()
    private let mediaViewerManager = MediaViewerManager()
    
    // MARK: - IPostRouter
    
    func postCommentView(_ view: PostCommentView, didTapFile index: Int) {
        print("didTapFile")
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int) {
        print("didTapAnswerButton")
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int) {
        print("didTapAnswersButton")
    }
    
    func postCommentView(_ view: PostCommentView,
                         didTapMoreButton post: Post,
                         thread: ThreadShortInfo,
                         boardId: String,
                         row: Int) {
        let bottomSheet = actionSheetFactory.createBottomSheet(post: post, threadInfo: (thread, boardId, row))
        viewHandler?.present(bottomSheet, animated: true)
    }
    
    func presentMediaController(source: MediaViewerManager.Source) {
        guard let mediaController = mediaViewerManager.mediaViewer(source: source) else { return }
        viewHandler?.present(mediaController, animated: true, completion: nil)
    }
}
