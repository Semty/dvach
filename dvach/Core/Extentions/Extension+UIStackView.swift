//
//  Extension+UIStackView.swift
//  FatFood
//
//  Created by Kirill Solovyov on 05.11.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis) {
        self.init()
        self.axis = axis
    }
}
