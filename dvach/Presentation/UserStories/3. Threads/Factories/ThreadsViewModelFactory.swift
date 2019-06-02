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
    
    func createThreadsViewModels(threads: [Thread]) -> [ThreadsPresenter.CellType] {
        var threadViewModels = [ThreadsPresenter.CellType]()
        
        threadViewModels = threads.compactMap { [weak self] thread in
            guard let `self` = self else { return nil}
            
            if let thumbnailPath = self.getThreadThumbnail(thread) {
                let threadWithImageViewModel =
                    ThreadWithImageView.Model(subjectTitle: thread.subject,
                                              commentTitle: thread.comment,
                                              dateTitle: thread.lastHit.convertTimestampToStringDate(),
                                              threadImageThumbnail: thumbnailPath)
                return .withImage(threadWithImageViewModel)
            } else {
                let threadWithoutImageViewModel =
                    ThreadWithoutImageView.Model(subjectTitle: thread.subject,
                                                 commentTitle: thread.comment,
                                                 dateTitle: thread.lastHit.convertTimestampToStringDate())
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
