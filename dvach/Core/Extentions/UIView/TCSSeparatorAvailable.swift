//
//  SeparatorAvailable.swift
//  TinkoffDesignKit
//
//  Created by i.bazarov on 06/02/2019.
//

import Foundation
import UIKit
// swiftlint:disable missing_docs
/// Общий протокол для вьюшек, на которые можно добавить сепаратор
public protocol SeparatorAvailable {
    
    /// Добавление сепаратора с заданным стилем
    @discardableResult
    func addSeparator(with style: SeparatorStyle, at edge: SeparatorEdge) -> UIView
    
    /// Удаление сепараоров с одной из сторон
    func removeSeparators(at edge: SeparatorEdge)
}

/// Стиль сепаратора
public struct SeparatorStyle {
    
    /// Отступы
    public let insets: SeparatorInsets
    /// Цвет
    public let color: UIColor
    /// Ширина
    public let width: CGFloat
    /// Инициализация значений
    public init(insets: SeparatorInsets, color: UIColor, width: CGFloat = 1 / UIScreen.main.scale) {
        self.insets = insets
        self.color = color
        self.width = width
    }
}

/// Отступы сепаратора
public struct SeparatorInsets {
    
    /// Левый отсуп для горизонтального сепаратора и верхний для вертикального
    public let first: CGFloat
    
    /// Правый отсуп для горизонтального сепаратора и нижний для вертикального
    public let second: CGFloat
    
    /// Инициализация значений
    public init(_ first: CGFloat, _ second: CGFloat) {
        self.first = first
        self.second = second
    }
    /// Инициализация значений
    public init(_ first: Double, _ second: Double) {
        self.init(CGFloat(first), CGFloat(second))
    }
    
    public static let zero = SeparatorInsets(0.0, 0.0)
}

/// Сторона крепления сепаратора
public enum SeparatorEdge: Int {
    case top = 232
    case bottom = 233
    case right = 234
    case left = 235
}

/// MARK: - Convenience & Computed (for backward compatibility)

public extension SeparatorAvailable {
    
    /// Добавление верхнего сепаратора
    func addTopSeparator(with style: SeparatorStyle) {
        addSeparator(with: style, at: .top)
    }
    
    /// Добавление нижнего сепаратора
    func addBottomSeparator(with style: SeparatorStyle) {
        addSeparator(with: style, at: .bottom)
    }
    
    /// Добавление левого сепаратора
    func addLeftSeparator(with style: SeparatorStyle) {
        addSeparator(with: style, at: .left)
    }
    
    /// Добавление правого сепаратора
    func addRightSeparator(with style: SeparatorStyle) {
        addSeparator(with: style, at: .right)
    }
    
    /// Удаление верхнего сепаратора
    func removeTopSeparator() {
        removeSeparators(at: .top)
    }
    
    /// Удаление нижнего сепаратора
    func removeBottomSeparator() {
        removeSeparators(at: .bottom)
    }
    
    /// Удаление левого сепаратора
    func removeLeftSeparator() {
        removeSeparators(at: .left)
    }
    
    /// Удаление правого сепаратора
    func removeRightSeparator() {
        removeSeparators(at: .right)
    }
}

/// Расширение протокола для настройки отступов сепаратора

public extension SeparatorInsets {
    
    /// Отступ слева
    var left: CGFloat {
        return first
    }
    
    /// Отступ справа
    var right: CGFloat {
        return second
    }
    
    /// Отступ сверху
    var top: CGFloat {
        return first
    }
    
    /// Отступ снизу
    var bottom: CGFloat {
        return second
    }
}

/// MARK: - UIView extension

public extension SeparatorAvailable where Self: UIView {
    
    @discardableResult
    func addSeparator(with style: SeparatorStyle, at edge: SeparatorEdge) -> UIView {
        let separatorView = UIView()
        
        separatorView.backgroundColor = style.color
        separatorView.tag = edge.rawValue
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separatorView)
        
        switch edge {
        case .top:
            separatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        case .bottom:
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        case .left:
            separatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        case .right:
            separatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
        switch edge {
        case .top, .bottom:
            separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: style.insets.left).isActive = true
            separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -style.insets.right).isActive = true
            separatorView.heightAnchor.constraint(equalToConstant: style.width).isActive = true
        case .left, .right:
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: style.insets.top).isActive = true
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -style.insets.bottom).isActive = true
            separatorView.widthAnchor.constraint(equalToConstant: style.width).isActive = true
        }
        
        return separatorView
    }
    /// Удаление сепараторов
    func removeSeparators(at edge: SeparatorEdge) {
        subviews.filter({ $0.tag == edge.rawValue }).forEach({ $0.removeFromSuperview()})
    }
}
