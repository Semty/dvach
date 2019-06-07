//
//  Extension+CAAnimation.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension CAAnimation {
    
    static var pulseAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        
        animation.duration = 0.5
        animation.fromValue = 1
        animation.toValue = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        return animation
    }
}
