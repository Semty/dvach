//
//  UIView+SeparatorAvailable.swift
//  MobileBank
//
//  Created by a.y.zverev on 29.08.17.
//  Copyright © 2017 АО «Тинькофф Банк», лицензия ЦБ РФ № 2673. All rights reserved.
//

import Foundation
import UIKit

public extension SeparatorAvailable where Self: UIView {
    
    var isBottomSeparatorExists: Bool {
        return isSeparatorAvailable(edge: .bottom)
    }
    
    private func isSeparatorAvailable(edge: SeparatorEdge) -> Bool {
        return subviews.contains(where: { $0.tag == edge.rawValue })
    }
}

public extension SeparatorStyle {
    
    init(insets: SeparatorInsets) {
        self.init(insets: insets, color: .n5LightGray)
    }
    
    static let defaultStyle = SeparatorStyle(insets: .default16Insets, color: .n5LightGray)
}

public extension SeparatorInsets {
    
    static let default16Insets: SeparatorInsets = SeparatorInsets(.inset16, .inset16)
}

open class SeparatorAvailableView: UIView, SeparatorAvailable {}
