//
//  DvachLink.swift
//  dvach
//
//  Created by Ruslan Timchenko on 10/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

public enum DvachLink {
    case board(String)
    case thread(boardId: String, threadId: String)
    case post(boardId: String, threadId: String, postId: String)
}

public extension Array where Element == DvachLink {
    
    var repliesIdentifiers: [String] {
        return compactMap {
            guard case .post(_, _, let postId) = $0 else { return nil }
            return postId
        }
    }
}
