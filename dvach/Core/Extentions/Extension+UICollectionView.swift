//
//  Extension+UICollectionView.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let reuseIdentifier = String(describing: T.self)
        
        if let nib = obtainNibIfExists(in: Bundle(for: T.self), withName: T.nibName()) {
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        let reuseIdentifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
        }
        
        return cell
    }
    
    // MARK: - Private
    
    /// Метод необходим, так как Nib из коробки не имеет failable initializer
    private func obtainNibIfExists(in bundle: Bundle, withName nibName: String) -> UINib? {
        return (bundle.path(forResource: nibName, ofType: "nib") != nil)
            ? UINib(nibName: nibName, bundle: bundle)
            : nil
    }
}
