//
//  HighlightingNonScrollableGestureRecognizer.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

public final class HighlightingNonScrollableGestureRecognizer: NonScrollableGestureRecognizer, UIGestureRecognizerDelegate {
    
    private let handler:((_ gestureRecognizer: UIGestureRecognizer) -> Void)?
    
    @objc public required init(handler:((_ gestureRecognizer: UIGestureRecognizer) -> Void)?) {
        self.handler = handler
        super.init(target: nil, action: nil)
        delegate = self
        self.addTarget(self, action: #selector(handleHighlighting(_:)))
    }
    
    // MARK: - Highlighting handler
    
    @objc private func handleHighlighting(_ gestureRecognizer: UIGestureRecognizer) {
        handler?(gestureRecognizer)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    /// Ловим нажатие на кнопку с активацией спецпредложения, и не даем в это время анимироватсья всему блоку
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return false }
        return !(touchView.allSubViewsOf(type: UIButton.self).contains(where: {$0.frame.contains(touch.location(in: touchView))}))
    }
}

private extension UIView {
    
    /// Рекурсивно достает все вьюхи нужного класса из текущей
    func allSubViewsOf<T: UIView>(type: T.Type) -> [T] {
        var allSubviews = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T {
                allSubviews.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)
        return allSubviews
    }
}
