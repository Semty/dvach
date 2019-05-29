//
//  Extension+UITableView.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func configureAutomaticDimensions(estimatedRowHeight: CGFloat) {
        self.estimatedRowHeight = estimatedRowHeight
        rowHeight = UITableView.automaticDimension
    }
    
    /// Метод регистрирует nib для ячейки, если существует nib с названием соответствующим ячейке.
    /// В противном случае метод регистрирует класс ячейки для переиспользования.
    ///
    /// Пример использования:
    ///
    ///     tableView.register(MyCell.self)
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        let reuseIdentifier = String(describing: T.self)
        
        if let nib = obtainNibIfExists(in: Bundle(for: T.self), withName: T.nibName()) {
            register(nib, forCellReuseIdentifier: reuseIdentifier)
        } else {
            register(cellClass, forCellReuseIdentifier: reuseIdentifier)
        }
    }
    
    /// Удобное регестрирование хедера/футера с ниб файлом для таблицы
    /// Использовать в коде так: `tableView.register(MyHeaderFooterView.self)`
    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        let reuseIdentifier = String(describing: T.self)
        let nib = UINib(nibName: T.nibName(), bundle: Bundle(for: T.self))
        register(nib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    /// Метод для переиспользования ячейки по nib или классу соответственно.
    ///
    /// Пример использования:
    ///
    ///     let cell: MyCell = tableView.dequeueReusableCell(forIndexPath: indexPath
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let reuseIdentifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
        }
        
        return cell
    }
    
    /// Удобный реюз хедера/футера для таблицы. Профит в том, что вернется хедер/футер сразу нужного класса уже неопциональный
    /// Использовать в коде так: `let headerFooterView = tableView.dequeueHeaderFooterView(MyHeaderFooterView.self)`
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
        let nibName = String(describing: T.self)
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: nibName) as? T else {
            fatalError("Could not dequeue cell with identifier: \(nibName)")
        }
        
        return headerFooter
    }
    
    // MARK: - Private
    
    /// Метод необходим, так как Nib из коробки не имеет failable initializer
    private func obtainNibIfExists(in bundle: Bundle, withName nibName: String) -> UINib? {
        return (bundle.path(forResource: nibName, ofType: "nib") != nil)
            ? UINib(nibName: nibName, bundle: bundle)
            : nil
    }
}
