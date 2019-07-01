//
//  AlertDisplayable.swift
//  dvach
//
//  Created by k.a.solovyev on 30/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol AlertDispayable where Self: UIViewController {
    /// Показывает алерт с ошибкой
    func showAlert(error: Error)
}

extension UIViewController: AlertDispayable {
    
    func showAlert(error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
