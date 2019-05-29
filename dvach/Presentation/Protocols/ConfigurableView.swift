//
//  ConfigurableView.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

/// Протокол конфигурируемого объекта отображения
public protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    /// Метод для конфигурации объекта отображения
    ///
    /// - Parameter model: ассоциированная модель
    func configure(with model: ConfigurationModel)
}
