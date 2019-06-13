//
//  Extension+UIImage.swift
//  FatFood
//
//  Created by Kirill Solovyov on 09.09.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UIImage {
    
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return img
    }
    
    static func icon(boardId: String) -> UIImage {
        let icon: UIImage
        if let assetsIcon = UIImage(named: boardId) {
            icon = assetsIcon
        } else {
            icon = UIImage(named: "default") ?? UIImage()
        }
        return icon
    }
}
