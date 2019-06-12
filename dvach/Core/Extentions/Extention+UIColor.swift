//
//  Extention+Color.swift
//  Receipt
//
//  Created by Kirill Solovyov on 22.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// Init with hex string in format "#RGB", "#RRGGBB", "#AARRGGBB"
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    // MARK: - Main colors

    static let n1Gray = UIColor(hexString: "#4A4A4A")
    static let n1GrayAlpha60 = UIColor.n1Gray.withAlphaComponent(0.6)
    static let n2Gray = UIColor(hexString: "#8E8E93")
    static let n3Purple = UIColor(hexString: "#645394")
    static let n4Red = UIColor(hexString: "#C74854")
    static let n5LightGray = UIColor(hexString: "#DEDEDE")
    static let n6Green = UIColor(hexString: "#417505")
    static let n7Blue = UIColor(hexString: "#4A90E2")
    static let n8SuperLightBlack = UIColor(hexString: "#000000").withAlphaComponent(0.05)
    static let n9LightGreen = UIColor(hexString: "#99C26F")
    static let n10WhiteIsh = UIColor(hexString: "#f5f5f5")
    static let n11EggYellow = UIColor(hexString: "#ffdc6a")
    static let n12Redline = UIColor(hexString: "#eb1736")
    
    /// Получение цвета от текста
    static func from(text: String) -> UIColor {
        return self.colors[self.codesSum(text: text) % colors.count]
    }
    
    // MARK: - Secondary colors
    
    static let a1Green = UIColor(hexString: "#7bc043")
    static let a2Yellow = UIColor(hexString: "#edc951")
    static let a3Orange = UIColor(hexString: "#f37736")
    static let a4Red = UIColor(hexString: "#ee4035")
    static let a5Purple = UIColor(hexString: "#8874a3")
    static let a6Blue = UIColor(hexString: "#0392cf")
    static let a7Purple = UIColor(hexString: "#9013FE")
    static let a8Pink = UIColor(hexString: "#B94AD0")
    
    // MARK: - Private
    
    private static var colors: [UIColor] = [.a1Green,
                                            .a2Yellow,
                                            .a3Orange,
                                            .a4Red,
                                            .a5Purple,
                                            .n7Blue,
                                            .n4Red,
                                            .n9LightGreen,
                                            .n2Gray,
                                            .a8Pink]
    
    private static func codesSum(text: String) -> Int {
        var result = 0
        var count = min(text.count, 6)
        text.forEach { character in
            guard count != 0 else { return }
            result += Int(String(character).utf16.first!)
            count -= 1
        }
        
        return result
    }
}
