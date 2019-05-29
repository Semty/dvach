//
//  ChildViewController.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

public protocol IChildViewController: class, NSObjectProtocol {
    
    // UIViewController Child-Parent relation support
    var view: UIView! { get }
    var parent: UIViewController? { get }
    func willMove(toParent: UIViewController?)
    func didMove(toParent: UIViewController?)
    func removeFromParent()
}

extension UIViewController: IChildViewController {
    public func addChildViewController(_ controller: IChildViewController) {
        guard let controller = controller as? UIViewController else { return }
        addChildViewController(controller)
    }
}

public protocol ReusableModule {
    
    /// Очистка сохраненных значений перед переиспользованием
    func prepareForReuse()
}

public protocol Validatable {
    func validate() -> Bool
}
