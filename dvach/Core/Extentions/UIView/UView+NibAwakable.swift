//
//  UView+NibAwakable.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit


public protocol NibAwakable {
    func awakeAfterCoder() -> Any?
}

extension NibAwakable where Self: UIView {
    
    public func awakeAfterCoder() -> Any? {
        
        // UIScrollView имеет 2 subview после инициализации, остальные 0
        let initialSubviewsCount = self is UIScrollView ? 2 : 0
        if self.subviews.count == initialSubviewsCount {
            guard let view = Bundle(for: type(of: self)).loadNibNamed(className, owner: nil, options: nil)?.first as? Self
                else { return self }
            
            // Переносим атрибуты self на view
            view.frame = self.frame
            view.autoresizingMask = self.autoresizingMask
            view.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints
            
            for constraint in self.constraints {
                
                var firstItem = constraint.firstItem as? NSObject
                if firstItem == self {
                    firstItem = view
                }
                
                var secondItem = constraint.secondItem as? NSObject
                if secondItem == self {
                    secondItem = view
                }
                
                let viewConstraint = NSLayoutConstraint(item: firstItem ?? constraint.firstItem as Any,
                                                        attribute: constraint.firstAttribute,
                                                        relatedBy: constraint.relation,
                                                        toItem: secondItem,
                                                        attribute: constraint.secondAttribute,
                                                        multiplier: constraint.multiplier,
                                                        constant: constraint.constant)
                view.addConstraint(viewConstraint)
            }
            return view
        }
        return self
    }
}
