//
//  SubscribesPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol ISubscribesPresenter {
    func viewDidLoad()
}

final class SubscribesPresenter {
    
    // Dependencies
    weak var view: SubscribesView?
    
}

// MARK: - ISubscribesPresenter

extension SubscribesPresenter: ISubscribesPresenter {
    
    func viewDidLoad() {
        
    }
}
