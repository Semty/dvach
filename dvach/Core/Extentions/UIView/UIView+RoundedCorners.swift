//
//  UIView+RoundedCorners.swift
//  dvach
//
//  Created by Kirill Solovyov on 04/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UIView {

    @discardableResult
    @objc public func roundCorners(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let shape = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        shape.path = path.cgPath
        layer.mask = shape
        return shape
    }
    
    @discardableResult
    @objc public func makeRounded() -> CAShapeLayer {
        return roundCorners(corners: .allCorners, radius: floor(bounds.height / 2))
    }
    
    public func makeRoundedByCornerRadius(_ radius: CGFloat? = nil) {
        layer.cornerRadius = radius ?? bounds.height / 2
        layer.masksToBounds = true
    }
}
