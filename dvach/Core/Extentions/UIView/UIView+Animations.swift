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
    
    func skeletonAnimation(skeletonView: UIView, mainView: UIView) {
        UIView.animateKeyframes(withDuration: 4/10, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 7/10,
                               animations: {
                skeletonView.alpha = 0.0
            })
            UIView.addKeyframe(withRelativeStartTime: 3/10,
                               relativeDuration: 7/10,
                               animations: {
                mainView.alpha = 1.0
            })
        }, completion:{ _ in
            skeletonView.isHidden = true
        })
    }
}
