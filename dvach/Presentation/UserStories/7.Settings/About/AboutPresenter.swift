//
//  AboutPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IAboutPresenter {
    func viewDidLoad()
}

final class AboutPresenter {
    
    // Dependencies
    weak var view: AboutView?
    
}

// MARK: - IAboutPresenter

extension AboutPresenter: IAboutPresenter {
    
    func viewDidLoad() {
        
    }
}
