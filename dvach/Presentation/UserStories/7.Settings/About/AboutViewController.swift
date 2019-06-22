//
//  AboutViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol AboutView: AnyObject {
    
}

final class AboutViewController: UIViewController {
    
    // Dependencies
    private let presenter: IAboutPresenter
    
    // MARK: - Initialization
    
    init() {
        let presenter = AboutPresenter()
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
        title = "О приложении"
        view.backgroundColor = .white
    }
}

// MARK: - AboutView

extension AboutViewController: AboutView {
    
}
