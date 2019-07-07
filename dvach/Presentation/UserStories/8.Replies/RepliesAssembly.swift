//
//  RepliesAssembly.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class RepliesAssembly {
    
    static func assemble(postId: String,
                         posts: [Post],
                         replies: Replies,
                         board: String,
                         thread: ThreadShortInfo) -> UIViewController {
        
        let router = PostRouter()
        let presenter = RepliesPresenter(postId: postId,
                                         posts: posts,
                                         replies: replies,
                                         router: router,
                                         board: board,
                                         thread: thread)
        let viewController = RepliesViewController(presenter: presenter)
        
        presenter.view = viewController
        router.viewHandler = viewController
        
        return viewController
    }
}
