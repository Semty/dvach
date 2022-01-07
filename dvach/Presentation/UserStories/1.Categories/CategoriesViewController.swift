//
//  CategoriesViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftEntryKit

protocol CategoriesView {
    
    // Обновление вью-моделей
    func update(viewModels: [CategoriesPresenter.BlockModel])
    
    // Метод необходимый для поиска
    func didLoadBoards(boards: [Board])
    
    // Показывает плейсхолдер при незагрузке бордов
    func showPlaceholder(text: String)
}

final class CategoriesViewController: UIViewController {
    
    // Dependencies
    private let presenter: ICategoriesPresenter
    private let componentsFactory = Locator.shared.componentsFactory()
    private let appSettingsStorage = Locator.shared.appSettingsStorage()

    // UI
    private var searchBoardsController: BoardsListViewController?
    private lazy var stackView: StackViewContainer = {
        let stackView = componentsFactory.createStackViewContainer()
        stackView.alpha = 0
        stackView.showsVerticalScrollIndicator = false
        
        return stackView
    }()
    private lazy var searchController = UISearchController(searchResultsController: searchBoardsController)
    private lazy var skeleton = CategoriesSkeletonView.fromNib()
    private lazy var placeholder = PlaceholderView()
    private lazy var updateButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateBoards))
    
    override var prefersStatusBarHidden: Bool {
        hideStatusBar(false, animation: true)
        return false
    }
    
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
        setupSearch()
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showEULAOfferIfNeeded()
    }
    
    // MARK: - Private
    
    private func showEULAOfferIfNeeded() {
        guard appSettingsStorage.isSafeMode, !appSettingsStorage.isEulaCompleted else { return }
        
        let vc = EULAOfferViewController()
        let attributes = vc.getAnimationAttributes()
        SwiftEntryKit.display(entry: vc, using: attributes)
    }
    
    private func setupSearch() {
        let boardsListViewController = BoardsListViewController(boards: [])
        boardsListViewController.delegate = self
        searchBoardsController = boardsListViewController
        
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
        skeleton.snp.makeConstraints {
            $0.top.equalTo(view.safeArea.top)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        skeleton.update(state: .active)
        
        // placeholder
        view.addSubview(placeholder)
        placeholder.snp.makeConstraints { $0.edges.equalToSuperview() }
        placeholder.isHidden = true
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
        horizontalList.selectionHandler = { [weak self] indexPath, _ in
            self?.presenter.didSelectCell(indexPath: indexPath, category: model.category)
        }
        
        return block
    }
    
    private func hideSkeleton() {
        skeleton.update(state: .nonactive)
        view.skeletonAnimation(skeletonView: skeleton, mainView: stackView)
    }
    
    private func hideUpdateButton(_ isHidden: Bool) {
        if isHidden {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = updateButton
        }
    }
    
    // MARK: - Actions
    
    @objc func updateBoards() {
        placeholder.isHidden = true
        skeleton.isHidden = false
        skeleton.update(state: .active)
        hideUpdateButton(true)
        presenter.didTapUpdate()
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
        
        if !skeleton.isHidden { hideSkeleton() }
        hideUpdateButton(true)
    }
    
    func didLoadBoards(boards: [Board]) {
        searchBoardsController?.update(boards: boards)
    }
    
    func showPlaceholder(text: String) {
        placeholder.configure(with: text + "\nПроверьте наличие интернета")
        placeholder.isHidden = false
        hideSkeleton()
        hideUpdateButton(false)
    }
}

// MARK: - BoardsListViewControllerDelegate

extension CategoriesViewController: BoardsListViewControllerDelegate {
    
    func didTap(board: Board) {
        presenter.didTap(board: board)
    }
}
