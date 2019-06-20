//
//  DTPhotoViewerControllerDataSource.swift
//  dvach
//
//  Created by Ruslan Timchenko on 18/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit

@objc public protocol DTPhotoViewerControllerDataSource: NSObjectProtocol {
    /// Total number of photo in viewer.
    func numberOfItems(in photoViewerController: DTMediaViewerController) -> Int
    
    /// Configure each photo in viewer
    /// Implementation for photoViewerController:configurePhotoAt:withImageView is mandatory.
    /// Not implementing this method will cause viewer not to work properly.
    func photoViewerController(_ photoViewerController: DTMediaViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView)
    
    /// This is usually used if you have custom DTPhotoCollectionViewCell and configure each photo differently.
    /// Remember this method cannot be a replacement of photoViewerController:configurePhotoAt:withImageView
    @objc optional func photoViewerController(_ photoViewerController: DTMediaViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int)
    
    /// This method provide the specific referenced view for each photo item in viewer that will be used for smoother dismissal transition.
    @objc optional func photoViewerController(_ photoViewerController: DTMediaViewerController, referencedViewForPhotoAt index: Int) -> UIView?
}
