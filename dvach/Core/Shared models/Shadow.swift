//
//  Shadow.swift
//  dvach
//
//  Created by Kirill Solovyov on 04/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

public struct Shadow {
    public let offsetX: CGFloat
    public let offsetY: CGFloat
    public let radius: CGFloat
    public let color: UIColor?
    public let opacity: CGFloat
    
    public static let `default` = Shadow(offsetX: 0, offsetY: 0, radius: 10, color: .black, opacity: 0.2)
}
