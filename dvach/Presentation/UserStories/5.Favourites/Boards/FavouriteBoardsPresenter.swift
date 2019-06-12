//
//  FavouriteBoardsPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 13/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IFavouriteBoardsPresenter {
    var dataSource: [BoardView.Model] { get }
    func viewDidLoad()
}

final class FavouriteBoardsPresenter {
    
    // Dependencies
    weak var view: (FavouriteBoardsView & UIViewController)?
    
    // Properties
    var dataSource = [BoardView.Model]()
    
    // MARK: - Private
}

// MARK: - IFavouriteBoardsPresenter

extension FavouriteBoardsPresenter: IFavouriteBoardsPresenter {
    
    func viewDidLoad() {
    
    }
}
