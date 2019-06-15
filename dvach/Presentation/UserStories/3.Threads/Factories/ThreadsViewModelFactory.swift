//
//  ThreadsViewModelFactory.swift
//  dvach
//
//  Created by Ruslan Timchenko on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class ThreadsViewModelFactory {
    
    // MARK: - Public Interface
    
    func createThreadsViewModels(threads: [Thread]) -> [BoardWithThreadsPresenter.CellType] {
        var threadViewModels = [BoardWithThreadsPresenter.CellType]()
        
        threadViewModels = threads.compactMap { [weak self] thread in
            guard let `self` = self else { return nil}
            guard var comment = thread.comment else { return nil }
            guard var subject = thread.subject else { return nil }
            
            comment = comment.parsed2chPost
            subject = subject.parsed2chSubject
            
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
        
        return threadViewModels
    }
    
    // MARK: - Private Interface
    private func getThreadThumbnail(_ thread: Thread) -> String? {
        if let threadImageThumbnail = thread.additionalInfo?.files.first?.thumbnail {
            return threadImageThumbnail
        } else {
            return nil
        }
    }
}
