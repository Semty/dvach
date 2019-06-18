//
//  DvachItem.swift
//  dvach
//
//  Created by Kirill Solovyov on 15/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

enum DvachItem {
    case board(BoardShortInfo)
    case thread(ThreadShortInfo, boardId: String?)
    case post(Post, threadInfo: ThreadShortInfo?, boardId: String?, rowIndex: Int)
    
    var identifier: String {
        switch self {
        case .board(let board): return board.identifier
        case .thread(let thread, _): return thread.identifier
        case .post(let post, _, _, _): return post.identifier
        }
    }
}
