//
//  Extension+View.swift
//  Receipt
//
//  Created by Kirill Solovyov on 22.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

extension UIView {
    
    @discardableResult
    public func autoSetDimension(_ dimension: ALDimension, toSize size: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: layoutAttribute(for: dimension),
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: size)
        
        constraint.priority = priority
        addConstraint(constraint)
        
        return constraint
    }
    
    public func firstAvailableUIViewController() -> UIViewController? {
        if let nextViewControllerResponder = self.next as? UIViewController {
            return nextViewControllerResponder
        } else if let nextViewResponder = self.next as? UIView {
            return nextViewResponder.firstAvailableUIViewController()
        }
        
        return nil
    }

    private func layoutAttribute(for dimension: ALDimension) -> NSLayoutConstraint.Attribute {
        switch dimension {
        case .height: return .height
        case .width: return .width
        default: return .height
        }
    }
    
    // MARK: - Shadows
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
