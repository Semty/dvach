//
//  CategoriesViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol CategoriesView: AnyObject {
    
    // Обновление вью-моделей
    func update(viewModels: [CategoriesPresenter.BlockModel])
    
    // Метод необходимый для поиска
    func didLoadBoards(boards: [Board])
}

final class CategoriesViewController: UIViewController {
    
    // Dependencies
    private let presenter: ICategoriesPresenter
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // UI
    private var searchBoardsController: BoardsListViewController?

    private lazy var stackView: StackViewContainer = {
        let stackView = componentsFactory.createStackViewContainer()
        stackView.alpha = 0.0
        return stackView
    }()
    private lazy var searchController = UISearchController(searchResultsController: searchBoardsController)
    private lazy var skeleton = CategoriesSkeletonView.fromNib()
    
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
        
        definesPresentationContext = true
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func setupSearch() {
        searchController.searchResultsUpdater = searchBoardsController
        searchController.searchBar.placeholder = "Название или идентификатор"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        
        // blocks
        view.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // skeleton
        view.addSubview(skeleton)
        skeleton.snp.makeConstraints { $0.edges.equalToSuperview() }
        skeleton.update(state: .active)
    }
    
    private func createBlock(model: CategoriesPresenter.BlockModel) -> BlockWithTitle {
        let block = componentsFactory.createBlockWithTitle()
        block.configure(with: model.blockModel)
        block.action = { [weak self] in
            self?.presenter.didTapAllBoards(category: model.category)
        }
        let horizontalList = HorizontalList<CategoriesCardCell>()
        block.addView(horizontalList)
        horizontalList.update(dataSource: model.collectionModels)
        horizontalList.selectionHandler = { [weak self] indexPath in
            self?.presenter.didSelectCell(indexPath: indexPath, category: model.category)
        }
        
        return block
    }
}

// MARK: - CategoriesView

extension CategoriesViewController: CategoriesView {
    
    func update(viewModels: [CategoriesPresenter.BlockModel]) {
        stackView.removeAllViews()
        viewModels.enumerated().forEach {
            let block = createBlock(model: $0.element)
            if viewModels.count == $0.offset + 1 { block.removeBottomSeparator() }
            stackView.addView(block)
        }
        
        if !skeleton.isHidden {
            skeleton.update(state: .nonactive)
            view.skeletonAnimation(skeletonView: skeleton, mainView: stackView)
        }
    }
    
    func didLoadBoards(boards: [Board]) {
        let boardsListViewController = BoardsListViewController(boards: boards)
        boardsListViewController.delegate = self
        searchBoardsController = boardsListViewController
        setupSearch()
    }
}

// MARK: - BoardsListViewControllerDelegate

extension CategoriesViewController: BoardsListViewControllerDelegate {
    
    func didTap(board: Board) {
        presenter.didTap(board: board)
    }
}
