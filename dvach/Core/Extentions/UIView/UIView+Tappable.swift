//
//  UIView+Tappable.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

private extension CGFloat {
    static let scale: CGFloat = 0.95
}

public protocol Tappable {
    func enableTapping(_ completion: @escaping () -> Void)
}

public extension Tappable where Self: UIView {
    
    func enableTapping(_ completion: @escaping () -> Void) {
        isUserInteractionEnabled = true
        
        let tapRecognizer = TapGestureRecognizer(handler: completion)
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func animateTapDown(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: .duration150, delay: 0, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: .scale, y: .scale)
        }, completion: completion)
    }
    
    func animateTabInside(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: .duration300, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: completion)
    }
}
