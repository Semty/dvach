//
//  Shadow.swift
//  dvach
//
//  Created by Kirill Solovyov on 04/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UIView {
    
    public func dropShadow(_ shadow: Shadow = .default) {
        layer.shadowOffset = CGSize(width: shadow.offsetX, height: shadow.offsetY)
        if let shadowColor = shadow.color {
            layer.shadowColor = shadowColor.cgColor
        }
        layer.shadowRadius = shadow.radius
        layer.shadowOpacity = Float(shadow.opacity)
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    public func removeShadow() {
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
    }
}
