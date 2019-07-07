//
//  MediaViewerViewModelFactory.swift
//  dvach
//
//  Created by Ruslan Timchenko on 28/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class MediaViewerViewModelFactory {
    
    func createMediaFileViewModels(_ files: [File], imageViews: [UIImageView]) -> [DTMediaViewerController.MediaFile] {
        
        let mediaFiles = files.enumerated().compactMap { index, file -> DTMediaViewerController.MediaFile in
            
            let type: DTMediaViewerController.MediaFile.MediaType
            
            switch file.type {
            case .gif, .jpg, .png, .sticker, .unknown:
                type = .image
            case .webm:
                type = .webm
            case .mp4:
                type = .mp4
            }
            
            let image = imageViews[safeIndex: index]?.image
            
            return
                DTMediaViewerController.MediaFile(type: type,
                                                  image: image,
                                                  urlPath: file.path)
        }
        
        return mediaFiles
    }
}
