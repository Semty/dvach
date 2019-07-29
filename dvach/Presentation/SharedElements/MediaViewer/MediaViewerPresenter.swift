//
//  MediaViewerPresenter.swift
//  dvach
//
//  Created by Ruslan Timchenko on 20/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SafariServices

public protocol IMediaViewerPresenter {
    func viewDidLoad()
    func didTapMoreButton()
    func openMediaFile(at url: URL, type: DTMediaViewerController.MediaFile.MediaType)
}

final class MediaViewerPresenter {
    
    weak var view: (MediaViewer & UIViewController)?
    
}

// MARK: - IMediaViewerPresenter

extension MediaViewerPresenter: IMediaViewerPresenter {
    
    func viewDidLoad() {
        
    }
    
    func didTapMoreButton() {
        
    }
    
    func openMediaFile(at url: URL, type: DTMediaViewerController.MediaFile.MediaType) {
        if type == .webm {
            openInVLC(url: url)
        } else {
            guard UIApplication.shared.canOpenURL(url) else { return }
            view?.lockController()
            let safariVC = SFSafariViewController(url: url)
            self.view?.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self.view
        }
    }
}

// MARK: - Webm Opener

extension MediaViewerPresenter {
    
    fileprivate func openInVLC(url: URL) {
        if let url = GlobalUtils.vlcScheme(urlPath: url) {
            UIApplication.shared.open(url, options: [:]) { [weak self] success in
                if !success {
                    let alert = UIAlertController.simpleAlert(title: "Ошибка",
                                                              message: "На данный момент NSFW Webm открывается только в VLC. Пожалуйста, установите VLC для просмотра данного контента", handler: nil)
                    self?.view?.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController.simpleAlert(title: "Ошибка",
                                                      message: "Мы не смогли получить корректный URL для данного медиафайла", handler: nil)
            view?.present(alert, animated: true, completion: nil)
        }
    }
}
