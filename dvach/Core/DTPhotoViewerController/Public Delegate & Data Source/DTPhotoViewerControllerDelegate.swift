//
//  DTPhotoViewerControllerDelegate.swift
//  dvach
//
//  Created by Ruslan Timchenko on 18/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit

@objc public protocol DTPhotoViewerControllerDelegate: NSObjectProtocol {
    @objc optional func photoViewerController(_ photoViewerController: DTMediaViewerController, didScrollToPhotoAt index: Int)
    
    @objc optional func photoViewerController(_ photoViewerController: DTMediaViewerController, didZoomOnPhotoAtIndex: Int, atScale scale: CGFloat)
    
    @objc optional func photoViewerController(_ photoViewerController: DTMediaViewerController, didEndZoomingOnPhotoAtIndex: Int, atScale scale: CGFloat)
    
    @objc optional func photoViewerController(_ photoViewerController: DTMediaViewerController, willZoomOnPhotoAtIndex: Int)
    
    @objc optional func photoViewerControllerDidReceiveTapGesture(_ photoViewerController: DTMediaViewerController)
    
    @objc optional func photoViewerControllerDidReceiveDoubleTapGesture(_ photoViewerController: DTMediaViewerController)
    
    @objc optional func photoViewerController(_ photoViewerController: DTMediaViewerController, willBeginPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer)
    
    @objc optional func photoViewerController(_ photoViewerController: DTMediaViewerController, didEndPanGestureRecognizer gestureRecognizer: UIPanGestureRecognizer)
    
    @objc optional func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTMediaViewerController)
    
    @objc optional func photoViewerController(_ photoViewerController: DTMediaViewerController, scrollViewDidScroll: UIScrollView)
}
