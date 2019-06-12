//
//  FavouritesPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 12/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IFavouritesPresenter {
    func viewDidLoad()
}

final class FavouritesPresenter {
    
    weak var view: FavouritesView?
    
}

// MARK: - IFavouritesPresenter

extension FavouritesPresenter: IFavouritesPresenter {
    
    func viewDidLoad() {
        
    }
}
