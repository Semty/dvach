//
//  BoardWithThreadsViewModelFactory.swift
//  dvach
//
//  Created by Ruslan Timchenko on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class BoardWithThreadsViewModelFactory {
    
    // MARK: - Public Interface
    
    func createThreadsViewModels(threads: [ChanThread]) -> [BoardWithThreadsPresenter.CellType] {
        return threads.compactMap { thread in
            guard let comment = thread.shortInfo.comment,
                let subject = thread.shortInfo.subject else { return nil }
            
            let postsCountTitle = "\(thread.postsCount) \(thread.postsCount.rightWordForPostsCount())"
            
            if let thumbnailPath = self.getThreadThumbnail(thread) {
                let threadWithImageViewModel =
                    ThreadWithImageView.Model(subjectTitle: subject,
                                              commentTitle: comment,
                                              postsCountTitle: postsCountTitle,
                                              threadImageThumbnail: thumbnailPath)
                return .withImage(threadWithImageViewModel)
            } else {
                let threadWithoutImageViewModel =
                    ThreadWithoutImageView.Model(subjectTitle: subject,
                                                 commentTitle: comment,
                                                 postsCountTitle: postsCountTitle)
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
