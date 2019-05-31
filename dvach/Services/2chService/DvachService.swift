//
//  DvachService.swift
//  dvach
//
//  Created by Kirill Solovyov on 30/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IDvachService {
    
    /// Загрузка всех досок (без тредов и дополнительной информации)
    func loadBoards(completion: @escaping (Result<[Board]>) -> Void)
    
    /// Загрузка конкретной доски (с тредами, отсортированными по последнему сообщению)
    func loadBoardWithBumpSortingThreads(_ board: String,
                                         completion: @escaping (Result<Board>) -> Void)
}

final class DvachService {
    
    // Dependencies
    private let requestManager: IRequestManager
    
    // MARK: - Initialization
    
    init(requestManager: IRequestManager) {
        self.requestManager = requestManager
    }
}

// MARK: - IDvachService

extension DvachService: IDvachService {
    
    func loadBoards(completion: @escaping (Result<[Board]>) -> Void) {
        let request = BoardsRequest()
        requestManager.loadModel(request: request) { result in
            switch result {
            case .success(let categories):
                // TODO: тут будет кеширование
                completion(.success(categories.boards))
            case .failure:
                completion(.failure(NSError.defaultError(description: "Борды не загрузились")))
            }
        }
    }
    
    func loadBoardWithBumpSortingThreads(_ board: String,
                                         completion: @escaping (Result<Board>) -> Void) {
        let request = BoardWithBumpSortingThreadsRequest(board)
        requestManager.loadModel(request: request) { result in
            switch result {
            case .success(let board):
                // TODO: тут будет кеширование
                completion(.success(board))
            case .failure:
                completion(.failure(NSError.defaultError(description: "Борда с тредами не загрузилась. Верим, что Абу не изменил API")))
            }
        }
    }
}
