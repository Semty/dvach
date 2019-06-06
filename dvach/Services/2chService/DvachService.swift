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
    
    /**
     Параметры:
     
     - board (String)  : Идентификатор доски
     - threadNum (Int) : Номер треда, равен параметру "num" в модели "Thread"
     - postNum (Int?)  : 1) Номер поста в треде. Первый пост - 1 и так далее
                         2) Номер поста на доске. Первый пост в треде равен
                         параметру threadNum, остальные - параметру "num"
                         в модели "Post"
     - location (PostNumberLocation?) : Местоположение номера поста - в треде или на доске
     
     Примечания:
     
        Можно загружать тред с постами используя как номер поста в треде, так и номер
     поста на доске.
     
        Если использовать номер поста в треде, то нужно обязательно указать, что
     location равен .inThread.
        Если использовать номер поста на доске, то нужно обязательно указать, что
     location равен .onBoard.
     
        Если параметр postNum будет равен nil, то ему присвоится значение 1.
        Если параметр location будет равен nil, то ему присвоится значение .inThread
    */
    
    /// Загрузка треда с постами
    func loadThreadWithPosts(board: String,
                             withThreadNum threadNum: Int,
                             startWithPostNumber postNum: Int?,
                             andLocation location: PostNumberLocation?,
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
                             startWithPostNumber postNum: Int?,
                             andLocation location: PostNumberLocation?,
                             completion: @escaping (Result<[Post]>) -> Void) {
        
        let request = ThreadWithPostsRequest(board: board,
                                             withThreadNum: thread,
                                             startWithPost: postNum ?? 1,
                                             andLocation: location ?? .inThread)
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
