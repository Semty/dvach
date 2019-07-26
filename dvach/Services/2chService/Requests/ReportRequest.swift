//
//  ReportRequest.swift
//  dvach
//
//  Created by Ruslan Timchenko on 25/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class ReportRequest: IRequest {
    
    typealias Model = ReportResponse
    
    let board: String
    let threadNum: String
    let postNum: String
    let comment: String
    
    // MARK: - Initialization
    
    init(board: String, threadNum: String, postNum: String, comment: String) {
        self.board = board
        self.threadNum = threadNum
        self.postNum = postNum
        self.comment = comment
    }
    
    // MARK: - IRequest
    
    var section: String {
        return "/makaba/makaba"
    }
    
    var format: String {
        return ".fcgi?json=1"
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var contentType: ContentType {
        return .multipartFormData
    }
    
    var parameters: [String : String] {
        return ["board": board,
                "thread": threadNum,
                "posts": postNum,
                "comment": comment,
                "task": "report"]
    }
}

