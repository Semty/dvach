//
//  PostBottomSheetFactory.swift
//  dvach
//
//  Created by Kirill Solovyov on 15/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class PostBottomSheetFactory {
    
    // Dependencies
    private let dvachService = Locator.shared.dvachService()
    
    // MARK: - Public
    
    func createBottomSheet(post: Post,
                           threadInfo: (thread: ThreadShortInfo, boardId: String, rowIndex: Int)?) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Пост
        let postItem = DvachItem.post(post,
                                      threadInfo: threadInfo?.thread,
                                      boardId: threadInfo?.boardId)
        if dvachService.isFavourite(postItem) {
            let removeThreadAction = UIAlertAction(title: "Удалить пост из избранного", style: .destructive) { [weak self] action in
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                self?.dvachService.removeFromFavourites(postItem)
            }
            actionSheet.addAction(removeThreadAction)
        } else {
            let saveThreadAction = UIAlertAction(title: "Сохранить пост в избранное", style: .default) { [weak self] action in
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                self?.dvachService.addToFavourites(postItem, completion: {})
            }
            actionSheet.addAction(saveThreadAction)
        }
        
        // Тред
        if let threadInfo = threadInfo {
            let threadItem = DvachItem.thread(threadInfo.thread, boardId: threadInfo.boardId)
            if dvachService.isFavourite(threadItem) {
                let removeThreadAction = UIAlertAction(title: "Убрать тред из избранного", style: .destructive) { [weak self] action in
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    self?.dvachService.removeFromFavourites(threadItem)
                }
                actionSheet.addAction(removeThreadAction)
            } else {
                let saveThreadAction = UIAlertAction(title: "Добавить тред в избранное", style: .default) { [weak self] action in
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    self?.dvachService.addToFavourites(threadItem, completion: {})
                }
                actionSheet.addAction(saveThreadAction)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }
}
