//
//  BoardWithBumpSortingThreadsRequest.swift
//  dvach
//
//  Created by Ruslan Timchenko on 31/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class BoardWithBumpSortingThreadsRequest: IRequest {
    
    private var board: String
    
    typealias Model = Board
    
    // MARK: - Initialization
    
    init(_ board: String) {
        self.board = board
    }
    
    // MARK: - IRequest
    var section: String {
        return "/\(board)/catalog"
    }
}
