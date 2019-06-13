//
//  DvachService.swift
//  dvach
//
//  Created by Kirill Solovyov on 30/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

final class DvachService {
    
    // Dependencies
    private let requestManager: IRequestManager
    private let storage: IStorage
    
    // MARK: - Initialization
    
    init(requestManager: IRequestManager, storage: IStorage) {
        self.requestManager = requestManager
        self.storage = storage
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
    
    func loadBoardWithBumpSortingThreadsCatalog(_ board: String,
                                                completion: @escaping (Result<Board>) -> Void) {
        let request = BoardWithBumpSortingThreadsCatalogRequest(board)
        requestManager.loadModel(request: request) { result in
            switch result {
            case .success(let board):
                completion(.success(board))
            case .failure:
                completion(.failure(NSError.defaultError(description: "Борда с тредами не загрузилась. Верим, что Абу не изменил API")))
            }
        }
    }
    
    func loadBoardWithPerPageThreadsRequest(_ board: String,
                                            _ page: Int,
                                            completion: @escaping (Result<Board>) -> Void) {
        let request = BoardWithPerPageThreadsRequest(board, page)
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
                             threadNum: Int,
                             postNum: Int?,
                             location: PostNumberLocation?,
                             completion: @escaping (Result<[Post]>) -> Void) {
        
        let request = ThreadWithPostsRequest(board: board,
                                             thread: threadNum,
                                             post: postNum ?? 1,
                                             location: location ?? .inThread)
        requestManager.loadModels(request: request) { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure:
                completion(.failure(NSError.defaultError(description: "Тред с постами не загрузился. Идем плакаться о ЕОТ в другое место (где есть интернет)")))
            }
        }
    }
    
    func markBoardAsFavourite(_ board: Board) {
        let favouriteBoard = FavouriteBoard(identifier: board.identifier,
                                            category: board.category ?? .other,
                                            name: board.name,
                                            timestamp: Date().timeIntervalSince1970)
        storage.save(objects: [favouriteBoard])
    }
    
    var favouriteBoards: [FavouriteBoard] {
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        return storage.fetch(model: FavouriteBoard.self, predicate: nil, sortDescriptors: [sortDescriptor])
    }
}
