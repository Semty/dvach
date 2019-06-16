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
                           threadInfo: (thread: ThreadShortInfo, boardId: String)?) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Пост
        if dvachService.isFavourite(.post(post)) {
            let removeThreadAction = UIAlertAction(title: "Удалить пост из избранного", style: .destructive) { [weak self] action in
                self?.dvachService.removeFromFavourites(.post(post))
            }
            actionSheet.addAction(removeThreadAction)
        } else {
            let saveThreadAction = UIAlertAction(title: "Сохранить пост в избранное", style: .default) { [weak self] action in
                self?.dvachService.addToFavourites(.post(post), completion: {})
            }
            actionSheet.addAction(saveThreadAction)
        }
        
        // Тред
        if let threadInfo = threadInfo {
            if dvachService.isFavourite(.thread(threadInfo.thread)) {
                let removeThreadAction = UIAlertAction(title: "Убрать тред из избранного", style: .destructive) { [weak self] action in
                    self?.dvachService.removeFromFavourites(.thread(threadInfo.thread))
                }
                actionSheet.addAction(removeThreadAction)
            } else {
                let saveThreadAction = UIAlertAction(title: "Добавить тред в избранное", style: .default) { [weak self] action in
                    self?.dvachService.addToFavourites(.thread(threadInfo.thread), boardId: threadInfo.boardId, completion: {})
                }
                actionSheet.addAction(saveThreadAction)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }
}
