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
    
    static let commentRegular = UIFont(name: "AvenirNext-Medium", size: 15.0)!
    static let commentEm = UIFont(name: "AvenirNext-MediumItalic", size: 15.0)!
    static let commentStrong = UIFont(name: "AvenirNext-DemiBold", size: 16.0)!
    static let commentEmStrong = UIFont(name: "AvenirNext-DemiBoldItalic", size: 16.0)!
}
