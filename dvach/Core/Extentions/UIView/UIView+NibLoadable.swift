//
//  UIView+NibLoadable.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewLoading {}

extension UIView: UIViewLoading {}

extension UIViewLoading where Self: UIView {
    
    static func isLoadableFromNib() -> Bool {
        let bundle = Bundle(for: self)
        return bundle.path(forResource: nibName(), ofType: "nib") != nil
    }
    
    static func fromNib() -> Self {
        let bundle = Bundle(for: self)
        
        guard let viewFromNib = bundle.loadNibNamed(nibName(), owner: self, options: nil)?.first as? Self else {
            fatalError("Can't load Nib with name \(String(describing: nibName))")
        }
        return viewFromNib
    }
    
    static func nibName() -> String {
        var nibName = self.className
        if let index = nibName.firstIndex(of: "<") {
            nibName = String(nibName[..<index])
        }
        return nibName
    }
}
