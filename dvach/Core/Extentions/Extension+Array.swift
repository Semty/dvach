//
//  Extension+Array.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {
    
    mutating func removeObject(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

extension Sequence where Iterator.Element: Hashable {
    var unique: [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

extension Array {
    
    public subscript(safeIndex index: Int) -> Element? {
        guard index < self.count else { return nil }
        
        return self[index]
    }
    
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index < self.count else { return defaultValue() }
        
        return self[index]
    }
}
