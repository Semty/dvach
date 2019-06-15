//
//  PostAssembly.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class PostAssembly {
    
    static func assemble(board: String, thread: Thread) -> UIViewController {
        let router = PostRouter()
        let presenter = PostViewPresenter(router: router, board: board, thread: thread)
        let viewController = PostViewController(presenter: presenter)
        
        presenter.view = viewController
        router.viewHandler = viewController
        
        return viewController
    }
}
