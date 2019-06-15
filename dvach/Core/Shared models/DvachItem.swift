//
//  DvachItem.swift
//  dvach
//
//  Created by Kirill Solovyov on 15/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

enum DvachItem {
    case board(Board)
    case thread(Thread)
    case post(Post)
    
    var identifier: String {
        switch self {
        case .board(let board): return board.identifier
        case .thread(let thread): return thread.identifier
        case .post(let post): return post.identifier
        }
    }
}
