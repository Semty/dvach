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
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int)
}

final class PostRouter: IPostRouter {
    
    weak var viewHandler: UIViewController?
    
    func postCommentView(_ view: PostCommentView, didTapFile index: Int) {
        print("didTapFile")
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int) {
        print("didTapAnswerButton")
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int) {
        print("didTapAnswersButton")
    }
    
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int) {
        print("didTapMoreButton")
    }
}
