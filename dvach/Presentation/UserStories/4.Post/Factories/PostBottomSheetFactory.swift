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
                           threadInfo: (thread: ThreadShortInfo, boardId: String, rowIndex: Int)?,
                           descriptionAlert: @escaping (UIAlertController?) -> Void,
                           successAlert: @escaping (UIAlertController?) -> Void) -> UIAlertController {
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
        
        // Репорт
        if let boardID = threadInfo?.boardId, let threadNum = threadInfo?.thread.number {
            let reportAction = UIAlertAction(title: "Пожаловаться", style: .destructive) { [weak self] action in
                
                let commentAlert = self?.askUserToWriteReportComment(completion: { comment in
                    guard let comment = comment else { return }
                    self?.dvachService.reportPost(board: boardID,
                                                  threadNum: "\(threadNum)",
                        postNum: post.number,
                        comment: comment,
                        qos: .userInitiated,
                        completion:
                        { [weak self] result in
                            switch result {
                            case .success(let reportResponse):
                                let reportAlert = self?.getReportResponseAlert(reportResponse)
                                successAlert(reportAlert)
                            case .failure(let error):
                                let errorAlert = self?.getErrorAlert(error.localizedDescription)
                                successAlert(errorAlert)
                            }
                    })
                    
                })
                
                descriptionAlert(commentAlert)
            }
            actionSheet.addAction(reportAction)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }
    
    private func askUserToWriteReportComment(completion: @escaping (String?) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Пожаловаться", message: "Пожалуйста, напишите причину", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = ""
        }
        
        let sendAction = UIAlertAction(title: "Отправить", style: .destructive) { action in
            if let textField = alert.textFields?.first {
                completion(textField.text)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { action in
            completion(nil)
        }
        
        alert.addAction(sendAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    private func getReportResponseAlert(_ reportResponse: ReportResponse) -> UIAlertController {
        let alert: UIAlertController
        if reportResponse.messageTitle == "Ошибка" {
            alert = UIAlertController.simpleAlert(title: reportResponse.messageTitle, message: reportResponse.message, handler: nil)
        } else {
            alert = UIAlertController.simpleAlert(title: "Жалоба отправлена", message: "Спасибо, что помогаете улучшить сообщество", handler: nil)
        }
        return alert
    }
    
    private func getErrorAlert(_ description: String) -> UIAlertController {
        let alert = UIAlertController.simpleAlert(title: "Ошибка", message: description, handler: nil)
        return alert
    }
}
