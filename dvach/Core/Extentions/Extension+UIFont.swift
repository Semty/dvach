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
    
    static let commentRegular = UIFont.systemFont(ofSize: 15.0, weight: .medium)
    static let commentEm = UIFont.systemFont(ofSize: 15.0,
                                             weight: .medium).with(.traitItalic)
    static let commentStrong = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
    static let commentEmStrong = UIFont.systemFont(ofSize: 16.0,
                                                   weight: .semibold).with(.traitItalic)
    
    // MARK: - Private Functions
    
    private func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    private func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
