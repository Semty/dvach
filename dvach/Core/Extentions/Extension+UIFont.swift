//
//  Extension+UIFont.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {
    
    typealias FontSize = CGFloat
    
    static func systemWith(size: FontSize) -> UIFont? {
        return UIFont(name: "systemFont", size: size)
    }
}
