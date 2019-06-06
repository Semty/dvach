//
//  ThreadWithPostsRequest.swift
//  dvach
//
//  Created by Ruslan Timchenko on 06/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class ThreadWithPostsRequest: IRequest {
    
    // Parameters
    
    private var board: String
    private var thread: Int
    private var post: Int
    
    // Model
    
    typealias Model = Post
    
    // MARK: - Initialization
    
    init(board: String, withThreadNum thread: Int, startWithPost post: Int) {
        self.board = board
        self.thread = thread
        self.post = post
    }
    
    // MARK: - IRequest
    var section: String {
        return "/makaba/mobile"
    }
    
    var format: String {
        return ".fcgi"
    }
    
    var parameters: [String : String] {
        return ["task": "get_thread",
                "board": board,
                "thread": "\(thread)",
                "post": "\(post)"]
    }
}
