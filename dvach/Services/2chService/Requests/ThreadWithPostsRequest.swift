//
//  ThreadWithPostsRequest.swift
//  dvach
//
//  Created by Ruslan Timchenko on 06/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

enum PostNumberLocation {
    case inThread
    case onBoard
}

final class ThreadWithPostsRequest: IRequest {
    
    // Parameters
    
    private var board: String
    private var thread: Int
    private var post: Int
    private var location: PostNumberLocation
    
    // Model
    
    typealias Model = Post
    
    // MARK: - Initialization
    
    init(board: String,
         withThreadNum thread: Int,
         startWithPost post: Int,
         andLocation location: PostNumberLocation) {
        self.board = board
        self.thread = thread
        self.post = post
        self.location = location
    }
    
    // MARK: - IRequest
    var section: String {
        return "/makaba/mobile"
    }
    
    var format: String {
        return ".fcgi"
    }
    
    var parameters: [String : String] {
        let postNumberParameter: String
        
        switch location {
        case .inThread:
            postNumberParameter = "post"
        case .onBoard:
            postNumberParameter = "num"
        }
        
        return ["task": "get_thread",
                "board": board,
                "thread": "\(thread)",
                postNumberParameter: "\(post)"]
    }
}
