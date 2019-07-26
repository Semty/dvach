//
//  BoardWithPerPageLoadThreadsRequest.swift
//  dvach
//
//  Created by Ruslan Timchenko on 13/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class BoardWithPerPageThreadsRequest: IRequest {
    
    private var board: String
    private var page: String
    
    typealias Model = Board
    
    // MARK: - Initialization
    
    init(_ board: String, _ page: Int) {
        self.board = board
        self.page = (page == 0 ? "index" : "\(page)")
    }
    
    // MARK: - IRequest
    
    var section: String {
        return "/\(board)/\(page)"
    }
}
