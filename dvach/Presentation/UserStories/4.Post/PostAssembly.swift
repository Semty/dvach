//
//  PostAssembly.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class PostAssembly {
    
    static func assemble(board: String, thread: ThreadShortInfo, scrollTo: Int = 0) -> UIViewController {
        let router = PostRouter()
        let presenter = PostViewPresenter(router: router, board: board, thread: thread, scrollTo: scrollTo)
        let viewController = PostViewController(presenter: presenter)
        
        presenter.view = viewController
        router.viewHandler = viewController
        
        return viewController
    }
}
