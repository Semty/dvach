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
        
        let defaultShadow = Shadow.default
        
        fillColor = UIColor.clear.cgColor
        shadowColor = defaultShadow.color?.cgColor ?? UIColor.black.cgColor
        shadowOpacity = Float(defaultShadow.opacity)
        shadowPath = path
        shadowOffset = CGSize(width: defaultShadow.offsetX, height: defaultShadow.offsetY)
        shadowRadius = defaultShadow.radius
        masksToBounds = false
    }
}
