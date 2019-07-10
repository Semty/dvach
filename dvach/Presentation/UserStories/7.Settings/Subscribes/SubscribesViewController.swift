//
//  SubscribesViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol SubscribesView: AnyObject {
    
}

final class SubscribesViewController: UIViewController {
    
    // Dependencies
    private let presenter: ISubscribesPresenter
    
    // MARK: - Initialization
    
    init() {
        let presenter = SubscribesPresenter()
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        title = "Подписки"
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
    }
}

// MARK: - SubscribesView

extension SubscribesViewController: SubscribesView {
    
}
