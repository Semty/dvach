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
}
