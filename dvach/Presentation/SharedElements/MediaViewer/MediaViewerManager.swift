//
//  MediaViewerManager.swift
//  dvach
//
//  Created by Kirill Solovyov on 21/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import FLAnimatedImage

extension CGFloat {
    static let contentInsetToClose: CGFloat = 60
}

final class MediaViewerManager {
    
    struct Source {
        let imageViews: [UIImageView]
        let files: [File]
        let imageIndex: Int
    }
    
    // Dependencies
    private let viewModelFactory = MediaViewerViewModelFactory()
    private let appSettingsStorage = Locator.shared.appSettingsStorage()
    
    // Properties
    private var imageViews = [UIImageView]()
    private var imageIndex = 0
    private var files = [File]()
    private var mediaFiles = [DTMediaViewerController.MediaFile]()
    
    // UI
    private var mediaViewer: MediaViewerController? {
        let mediaFiles = viewModelFactory.createMediaFileViewModels(files,
                                                                    imageViews: imageViews)
        let mediaViewer = MediaViewerController(referencedViews: imageViews,
                                                files: mediaFiles,
                                                index: imageIndex)
        
        mediaViewer.mediaViewControllerDataSource = self
        mediaViewer.mediaViewControllerDelegate = self
        self.mediaFiles = mediaFiles
        
        return mediaViewer
    }
    
    // MARK: - Public
    
    public func mediaViewer(source: Source) -> MediaViewerController? {
        imageViews = source.imageViews
        files = source.files
        imageIndex = source.imageIndex
        
        return mediaViewer
    }
}

// MARK: - DTMediaViewerControllerDataSource

extension MediaViewerManager: DTMediaViewerControllerDataSource {
    
    func photoViewerController(_ photoViewerController: DTMediaViewerController,
                               referencedViewForPhotoAt index: Int) -> UIImageView? {
        return imageViews[safeIndex: index]
    }
    
    func numberOfItems(in photoViewerController: DTMediaViewerController) -> Int {
        return mediaFiles.count
    }
    
    func photoViewerController(_ photoViewerController: DTMediaViewerController,
                               configurePhotoAt index: Int,
                               withImageView imageView: FLAnimatedImageView) {
        let file = mediaFiles[index]
        if file.type == .image, let image = file.image, !image.isNFFW {
            ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
            imageView.loadImage(url: file.urlPath ?? "",
                                defaultImage: file.image,
                                placeholder: file.image,
                                transition: false,
                                checkNSFW: false,
                                isSafeMode: appSettingsStorage.isSafeMode)
        } else {
            imageView.image = file.image
        }
    }
    
    func photoViewerController(_ photoViewerController: DTMediaViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
        let file = mediaFiles[index]
        cell.configure(file.image, urlPath: file.urlPath, isSafeMode: appSettingsStorage.isSafeMode)
    }
    
    func mediaViewerController(_ mediaViewerController: DTMediaViewerController, configureCell cell: VideoContainer, forVideoAt index: Int) {
        let file = mediaFiles[index]
        cell.configure(urlPath: file.urlPath, image: file.image)
    }
}

// MARK: - DTMediaViewerControllerDelegate

extension MediaViewerManager: DTMediaViewerControllerDelegate {
    
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTMediaViewerController) {
        photoViewerController.scrollToPhoto(at: imageIndex, animated: false)
    }
    
    func photoViewerController(_ photoViewerController: DTMediaViewerController, didScrollToPhotoAt index: Int) {
        if imageViews.count == index {
            photoViewerController.dismiss(animated: true)
        } else {
            imageIndex = index
        }
    }
    
    func photoViewerController(_ photoViewerController: DTMediaViewerController, scrollViewDidScroll: UIScrollView) {
        if scrollViewDidScroll.contentOffset.x > scrollViewDidScroll.contentSize.width - scrollViewDidScroll.bounds.width + .contentInsetToClose {
            if UIDevice.current.isPortrait {
                (photoViewerController as? MediaViewerController)?.configureSecondaryViews(hidden: true, animated: false)
                photoViewerController.dismiss(animated: true)
            }
        }
    }
}

