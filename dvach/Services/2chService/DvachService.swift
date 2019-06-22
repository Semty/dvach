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
    
    func loadBoards(qos: DispatchQoS, completion: @escaping (Result<[Board]>) -> Void) {
        let request = BoardsRequest()
        requestManager.loadModel(request: request, qos: qos) { result in
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
                                                qos: DispatchQoS,
                                                completion: @escaping (Result<Board>) -> Void) {
        let request = BoardWithBumpSortingThreadsCatalogRequest(board)
        requestManager.loadModel(request: request, qos: qos) { result in
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
                                            qos: DispatchQoS,
                                            completion: @escaping (Result<Board>) -> Void) {
        let request = BoardWithPerPageThreadsRequest(board, page)
        requestManager.loadModel(request: request, qos: qos) { result in
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
                             qos: DispatchQoS,
                             completion: @escaping (Result<[Post]>) -> Void) {
        
        let request = ThreadWithPostsRequest(board: board,
                                             thread: threadNum,
                                             post: postNum ?? 1,
                                             location: location ?? .inThread)
        requestManager.loadModels(request: request, qos: qos) { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure:
                completion(.failure(NSError.defaultError(description: "Тред с постами не загрузился. Идем плакаться о ЕОТ в другое место (где есть интернет)")))
            }
        }
    }
    
    // MARK: - Shown Boards
    
    func dropAllShownBoards() {
        storage.deleteAll(objects: ShownBoard.self)
    }
    
    func markBoardAsShown(identifier: String) {
        let shownBoard = ShownBoard(identifier: identifier)
        storage.save(objects: [shownBoard])
    }
    
    func isBoardShown(identifier: String) -> Bool {
        let shownBoards = storage.fetch(model: ShownBoard.self)
        return shownBoards.contains(where: { $0.identifier == identifier })
    }
    
    // MARK: - Favourites
    
    func addToFavourites(_ item: DvachItem, completion: @escaping () -> Void) {
        switch item {
        case .board(let board):
            storage.save(objects: [board], completion: completion)
        case .thread(var thread, let boardId):
            thread.boardId = boardId
            storage.save(objects: [thread], completion: completion)
        case .post(var post, var threadShortInfo, let boardId, let rowIndex):
            threadShortInfo?.isFavourite = false
            threadShortInfo?.boardId = boardId
            threadShortInfo?.identifier = post.identifier // Нужно для того, чтобы тред не попал в избранное вместе с постом
            post.threadInfo = threadShortInfo
            post.rowIndex = rowIndex
            storage.save(objects: [post], completion: completion)
        }
    }
    
    func removeFromFavourites(_ item: DvachItem) {
        switch item {
        case .board:
            storage.delete(model: BoardShortInfo.self, with: item.identifier)
        case .thread:
            storage.delete(model: ThreadShortInfo.self, with: item.identifier)
        case .post:
            storage.delete(model: Post.self, with: item.identifier)
        }
    }
    
    func favourites<T: Persistable>(type: T.Type) -> [T] {
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        return storage.fetch(model: type, predicate: nil, sortDescriptors: [sortDescriptor])
    }
    
    func isFavourite(_ item: DvachItem) -> Bool {
        let predicate = NSPredicate(format: "identifier == %@", item.identifier)
        switch item {
        case .board:
            let board = storage.fetch(model: BoardShortInfo.self, predicate: predicate, sortDescriptors: [])
            return board.first != nil
        case .thread:
            let thread = storage.fetch(model: ThreadShortInfo.self, predicate: predicate, sortDescriptors: [])
            return thread.first?.isFavourite == true
        case .post:
            let post = storage.fetch(model: Post.self, predicate: predicate, sortDescriptors: [])
            return post.first != nil
        }
    }
}
