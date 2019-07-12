//
//  BoardsListViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 04/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol BoardsListViewControllerDelegate: AnyObject {
    func didTap(board: Board)
}

protocol BoardsListView: AnyObject {
    func updateTable()
    func didSelectBoard(_ board: Board)
}

final class BoardsListViewController: UIViewController {
    
    // Dependencies
    weak var delegate: BoardsListViewControllerDelegate?
    private let presenter: IBoardsListPresenter
        
    // UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BoardCell.self)
        tableView.rowHeight = .defaultRowHeight
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        return tableView
    }()
    private var popRecognizer: SwipeToBackRecognizer?
    
    // MARK: - Initialization

    init(boards: [Board]) {
        let presenter = BoardsListPresenter(boards: boards)
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func update(boards: [Board]) {
        presenter.update(boards: boards)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackBarButton()
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPopRecognizer()
    }
    
    // MARK: - Private
    
    private func setupBackBarButton() {
        let backItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        backItem.tintColor = .n1Gray
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupPopRecognizer() {
        guard let controller = navigationController else { return }
        popRecognizer = SwipeToBackRecognizer(controller: controller)
        navigationController?.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
}

// MARK: - BoardsListView

extension BoardsListViewController: BoardsListView {
    
    func updateTable() {
        tableView.reloadData()
    }
    
    func didSelectBoard(_ board: Board) {
        delegate?.didTap(board: board)
    }
}

// MARK: - UITableViewDataSource

extension BoardsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BoardCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.prepareForReuse()
        let viewModel = presenter.dataSource[indexPath.row]
        cell.configure(with: viewModel)
        if indexPath.row == presenter.dataSource.count - 1 {
            cell.containedView.removeBottomSeparator()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BoardsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectBoard(index: indexPath.row)
    }
}

// MARK: - UISearchResultsUpdating

extension BoardsListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        presenter.searchBoard(for: searchController.searchBar.text?.lowercased())
    }
}
