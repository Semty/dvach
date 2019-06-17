//
//  IDvachService.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IDvachService {
    
    /// Загрузка всех досок (без тредов и дополнительной информации)
    func loadBoards(qos: DispatchQoS, completion: @escaping (Result<[Board]>) -> Void)
    
    /// Загрузка конкретной доски (с каталогом тредов, отсортированных по последнему сообщению)
    func loadBoardWithBumpSortingThreadsCatalog(_ board: String,
                                                qos: DispatchQoS,
                                                completion: @escaping (Result<Board>) -> Void)
    
    /// Загрузка конкретной доски с тредами по странице
    func loadBoardWithPerPageThreadsRequest(_ board: String,
                                            _ page: Int,
                                            qos: DispatchQoS,
                                            completion: @escaping (Result<Board>) -> Void)
    
    /*
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
                             threadNum: Int,
                             postNum: Int?,
                             location: PostNumberLocation?,
                             qos: DispatchQoS,
                             completion: @escaping (Result<[Post]>) -> Void)
    
    // MARK: - Избранное
    
    /// Добавить в избранное
    func addToFavourites(_ item: DvachItem, completion: @escaping () -> Void)
    
    /// Убрать из избранного
    func removeFromFavourites(_ item: DvachItem)
    
    /// Достать список избранного из кеша
    func favourites<T: Persistable>(type: T.Type) -> [T]
    
    /// Проверка на то, добавлен ли объект в избранное
    func isFavourite(_ item: DvachItem) -> Bool
}

extension IDvachService {
    
    func loadBoards(qos: DispatchQoS = .userInitiated,
                    completion: @escaping (Result<[Board]>) -> Void) {
        loadBoards(qos: qos, completion: completion)
    }
    
    func loadBoardWithBumpSortingThreadsCatalog(_ board: String,
                                                qos: DispatchQoS = .userInitiated,
                                                completion: @escaping (Result<Board>) -> Void) {
        loadBoardWithBumpSortingThreadsCatalog(board,
                                               qos: qos,
                                               completion: completion)
    }
    
    func loadBoardWithPerPageThreadsRequest(_ board: String,
                                            _ page: Int,
                                            qos: DispatchQoS = .userInitiated,
                                            completion: @escaping (Result<Board>) -> Void) {
        loadBoardWithPerPageThreadsRequest(board,
                                           page,
                                           qos: qos,
                                           completion: completion)
    }
    
    func loadThreadWithPosts(board: String,
                             threadNum: Int,
                             postNum: Int?,
                             location: PostNumberLocation?,
                             qos: DispatchQoS = .userInitiated,
                             completion: @escaping (Result<[Post]>) -> Void) {
        loadThreadWithPosts(board: board,
                            threadNum: threadNum,
                            postNum: postNum,
                            location: location,
                            qos: qos,
                            completion: completion)
    }
}
