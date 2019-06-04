//
//  NonScrollableGestureRecognizer.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let distanceToScroll: CGFloat = 10
}

/// GestureRecognizer, который отменяет жест, если зажатый палец сместился на некое расстояние по оси Y
public class NonScrollableGestureRecognizer: UIGestureRecognizer {
    
    private var initialTouchPoint: CGPoint?
    
    override public func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
        self.initialTouchPoint = touches.first?.location(in: view)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        guard let touchPoint = touches.first?.location(in: view), let initialTouchPoint = self.initialTouchPoint else {
            self.state = .cancelled
            return
        }
        
        if abs(touchPoint.y - initialTouchPoint.y) > .distanceToScroll {
            self.state = .cancelled
        } else {
            self.state = .changed
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        self.state = .ended
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        self.state = .cancelled
    }
    
    public override func reset() {
        super.reset()
        initialTouchPoint = nil
    }
}
