//
//  CategoriesViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol CategoriesView: AnyObject {
    func update(viewModels: [CategoriesPresenter.BlockModel])
}

final class CategoriesViewController: UIViewController {
    
    // Dependencies
    private let presenter: ICategoriesPresenter
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // UI
    private lazy var stackView = componentsFactory.createStackViewContainer()
    
    // MARK: - Initialization
    
    init() {
        let presenter = CategoriesPresenter()
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func createBlock(model: CategoriesPresenter.BlockModel) -> UIView {
        let block = componentsFactory.createBlockWithTitle()
        block.configure(with: model.blockModel)
        let horizontal = HorizontalList<CategoriesCardCell>()
        block.addView(horizontal)
        horizontal.update(dataSource: model.collectionModels)

        return block
    }
}

// MARK: - CategoriesView

extension CategoriesViewController: CategoriesView {
    
    func update(viewModels: [CategoriesPresenter.BlockModel]) {
        stackView.removeAllViews()
        viewModels.forEach {
            let block = createBlock(model: $0)
            stackView.addView(block)
        }
    }
}
