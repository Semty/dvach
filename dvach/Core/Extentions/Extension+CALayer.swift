//
//  Extension+CALayer.swift
//  dvach
//
//  Created by Ruslan Timchenko on 02/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension CAShapeLayer {
    func addThreadShadow(aroundRoundedRect rect: CGRect) {
        path = UIBezierPath(roundedRect: rect,
                            cornerRadius: 12).cgPath
        
        fillColor = UIColor.clear.cgColor
        shadowColor = UIColor.black.cgColor
        shadowOpacity = 0.125
        shadowPath = path
        shadowOffset = .zero
        shadowRadius = 5
    }
}
