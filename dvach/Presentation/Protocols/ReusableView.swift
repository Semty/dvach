//
//  ReusableView.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

/// Протокол переиспользуемого объекта отображения
public protocol ReusableView {
    
    /// Метод для подготовки объекта к переиспользованию
    func prepareForReuse()
}

public extension ReusableView {
    func prepareForReuse() {}
}
