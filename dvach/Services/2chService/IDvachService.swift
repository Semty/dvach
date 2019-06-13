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
    func loadBoards(completion: @escaping (Result<[Board]>) -> Void)
    
    /// Загрузка конкретной доски (с каталогом тредов, отсортированных по последнему сообщению)
    func loadBoardWithBumpSortingThreadsCatalog(_ board: String,
                                                completion: @escaping (Result<Board>) -> Void)
    
    /// Загрузка конкретной доски с тредами по странице
    func loadBoardWithPerPageThreadsRequest(_ board: String,
                                            _ page: Int,
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
                             completion: @escaping (Result<[Post]>) -> Void)
    
    /// Добавить доску в избранное
    func markBoardAsFavourite(_ board: Board)
    
    /// Достать список избранных досок из кеша
    var favouriteBoards: [FavouriteBoard] { get }
}
