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
    
    /// Загрузка треда с постами (номер поста начинается с 1)
    func loadThreadWithPosts(board: String,
                             withThreadNum thread: Int,
                             startWithPost post: Int?,
                             completion: @escaping (Result<[Post]>) -> Void)
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
                completion(.failure(NSError.defaultError(description: "Борды не загрузились. Вот так, в самом начале пути. Да, как всегда")))
            }
        }
    }
    
    func loadBoardWithBumpSortingThreads(_ board: String,
                                         completion: @escaping (Result<Board>) -> Void) {
        let request = BoardWithBumpSortingThreadsRequest(board)
        requestManager.loadModel(request: request) { result in
            switch result {
            case .success(let board):
                completion(.success(board))
            case .failure:
                completion(.failure(NSError.defaultError(description: "Борда с тредами не загрузилась. Верим, что Абу не изменил API")))
            }
        }
    }
    
    func loadThreadWithPosts(board: String,
                             withThreadNum thread: Int,
                             startWithPost post: Int?,
                             completion: @escaping (Result<[Post]>) -> Void) {
        let request = ThreadWithPostsRequest(board: board,
                                             withThreadNum: thread,
                                             startWithPost: post ?? 1)
        requestManager.loadModels(request: request) { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure:
                completion(.failure(NSError.defaultError(description: "Тред с постами не загрузился. Идем плакаться о ЕОТ в другое место (где есть интернет)")))
            }
        }
    }
}
