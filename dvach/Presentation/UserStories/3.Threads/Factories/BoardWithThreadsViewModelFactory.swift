//
//  BoardWithThreadsViewModelFactory.swift
//  dvach
//
//  Created by Ruslan Timchenko on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class BoardWithThreadsViewModelFactory {
    
    // Dependencies
    private let appSettingsStorage = Locator.shared.appSettingsStorage()
    private let profanityCensor = Locator.shared.profanityCensor()
    
    // MARK: - Public Interface
    
    func createThreadsViewModels(threads: [ChanThread]) -> [BoardWithThreadsPresenter.CellType] {
        let isSafeMode = appSettingsStorage.isSafeMode
        return threads.compactMap { thread in
            guard let comment = thread.shortInfo.comment,
                let subject = thread.shortInfo.subject else { return nil }
            
            let censorComment = isSafeMode ? profanityCensor.censor(comment, symbol: "*") : comment
            let censorSubject = isSafeMode ? profanityCensor.censor(subject, symbol: "*") : subject
            
            let postsCountTitle = "\(thread.postsCount) \(thread.postsCount.rightWordForPostsCount())"
            
            let id = thread.shortInfo.identifier
            
            if let thumbnailPath = self.getThreadThumbnail(thread) {
                let threadWithImageViewModel =
                    ThreadWithImageView.Model(subjectTitle: censorSubject,
                                              commentTitle: censorComment,
                                              postsCountTitle: postsCountTitle,
                                              threadImageThumbnail: thumbnailPath,
                                              id: id,
                                              isSafeMode: isSafeMode)
                return .withImage(threadWithImageViewModel)
            } else {
                let threadWithoutImageViewModel =
                    ThreadWithoutImageView.Model(subjectTitle: censorSubject,
                                                 commentTitle: censorComment,
                                                 postsCountTitle: postsCountTitle,
                                                 id: id)
                return .withoutImage(threadWithoutImageViewModel)
            }
        }
    }
    
    // MARK: - Private Interface
    private func getThreadThumbnail(_ thread: ChanThread) -> String? {
        guard let threadImageThumbnail = thread.additionalInfo?.files.first?.thumbnail else { return nil }
        return threadImageThumbnail
    }
}
