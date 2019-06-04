//
//  HighlightingGestureRecognizer.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

/// GestureRecognizer, который ловит начало нажатия (.began) и конец нажатия (.ended)
public final class HighlightingGestureRecognizer: TouchGestureRecognizer {
    
    private let handler:((_ gestureRecognizer: UIGestureRecognizer) -> Void)?
    
    @objc public required init(handler:((_ gestureRecognizer: UIGestureRecognizer) -> Void)?) {
        self.handler = handler
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(handleHighlighting(_:)))
    }
    
    // MARK: - Highlighting handler
    
    @objc private func handleHighlighting(_ gestureRecognizer: UIGestureRecognizer) {
        handler?(gestureRecognizer)
    }
}
