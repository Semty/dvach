//
//  MediaViewerPresenter.swift
//  dvach
//
//  Created by Ruslan Timchenko on 20/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

public protocol IMediaViewerPresenter {
    func viewDidLoad()
    func didTapMoreButton()
}

final class MediaViewerPresenter {
    
    weak var view: MediaViewer?
    
}

extension MediaViewerPresenter: IMediaViewerPresenter {
    
    func viewDidLoad() {
        
    }
    
    func didTapMoreButton() {
        
    }
}
