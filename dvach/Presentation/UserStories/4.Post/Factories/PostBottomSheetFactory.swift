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
    
    func createBottomSheet(thread: ThreadShortInfo, boardId: String) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if dvachService.isFavourite(.thread(thread)) {
            let removeThreadAction = UIAlertAction(title: "Убрать тред из избранного", style: .destructive) { [weak self] action in
                self?.dvachService.removeFromFavourites(.thread(thread))
            }
            actionSheet.addAction(removeThreadAction)
        } else {
            let saveThreadAction = UIAlertAction(title: "Добавить тред в избранное", style: .default) { [weak self] action in
                self?.dvachService.addToFavourites(.thread(thread), boardId: boardId, completion: {})
            }
            actionSheet.addAction(saveThreadAction)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        return actionSheet
    }
}
