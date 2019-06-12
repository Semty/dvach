//
//  FavouriteBoardsViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 13/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol FavouriteBoardsView {
    
}

final class FavouriteBoardsViewController: UIViewController {
    
    // Dependencies
    private let presenter: IFavouriteBoardsPresenter
    
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
    
    // MARK: - Initialization
    
    init() {
        let presenter = FavouriteBoardsPresenter()
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
        view.backgroundColor = .blue
//        view.addSubview(tableView)
//        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

// MARK: - FavouriteBoardsView

extension FavouriteBoardsViewController: FavouriteBoardsView {
    
}

// MARK: - UITableViewDataSource

extension FavouriteBoardsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BoardCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let viewModel = presenter.dataSource[indexPath.row]
        cell.configure(with: viewModel)
        if indexPath.row == presenter.dataSource.count - 1 {
            cell.containedView.removeBottomSeparator()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavouriteBoardsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter.didSelectBoard(index: indexPath.row)
    }
}
