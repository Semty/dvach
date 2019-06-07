//
//  UIView+Animations.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UIView {
    
    func addPulseAnimation() {
        layer.add(.pulseAnimation, forKey: "pulseAnimation")
    }
    
    func removePulseAnimation() {
        layer.removeAnimation(forKey: "pulseAnimation")
    }
    
    var isHiddenFadeAnimated: Bool {
        set {
            updateHiddenFadeAnimated(isHidden: newValue, duration: 3)
        }
        get {
            return self.isHidden
        }
    }
    
    func updateHiddenFadeAnimated(isHidden: Bool, duration: TimeInterval) {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = duration
        layer.add(transition, forKey: nil)
        self.isHidden = isHidden
    }
}
