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
    static let contentInsetToClose: CGFloat = 100
}

final class MediaViewerManager {
    
    struct Source {
        let imageViews: [UIImageView]
        let files: [File]
        let imageIndex: Int
    }
    
    // Properties
    private var imageViews = [UIImageView]()
    private var imageIndex = 0
    private var files = [File]()
    
    // UI
    private var mediaViewer: MediaViewerController? {
        guard let imageView = imageViews[safeIndex: imageIndex] else { return nil }
        let mediaViewer = MediaViewerController(referencedView: imageView,
                                                image: imageView.image)
        
        mediaViewer.dataSource = self
        mediaViewer.delegate = self
        
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
                               referencedViewForPhotoAt index: Int) -> UIView? {
        return imageViews[safeIndex: index]
    }
    
    func numberOfItems(in photoViewerController: DTMediaViewerController) -> Int {
        return imageViews.count
    }
    
    func photoViewerController(_ photoViewerController: DTMediaViewerController,
                               configurePhotoAt index: Int,
                               withImageView imageView: FLAnimatedImageView) {
        let file = files[index]
        let thumbnailImage = imageViews[safeIndex: index]?.image
        if file.type == .gif
            || file.type == .jpg
            || file.type == .png
            || file.type == .sticker {
            ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
            imageView.loadImage(url: file.path,
                                defaultImage: thumbnailImage,
                                placeholder: thumbnailImage,
                                transition: false)
        } else {
            imageView.image = thumbnailImage
        }
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
            (photoViewerController as? MediaViewerController)?.configureSecondaryViews(hidden: true, animated: false)
            photoViewerController.dismiss(animated: true)
        }
    }
}

