//
//  FavouriteThreadsViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 13/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol FavouriteThreadsView {
    func updateTable()
}

final class FavouriteThreadsViewController: UIViewController {
    
    // Dependencies
    private let presenter: IFavouriteThreadsPresenter
    
    // UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavouriteThreadCell.self)
        tableView.rowHeight = 110
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.isHidden = true
        
        return tableView
    }()
    
    private lazy var placeholderView: UIView = {
        let label = UILabel()
        label.text = "У вас пока нет любимых тредов"
        label.textColor = .n2Gray
        label.textAlignment = .center
        let view = UIView()
        view.addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        return view
    }()
    
    // MARK: - Initialization
    
    init() {
        let presenter = FavouriteThreadsPresenter()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(placeholderView)
        placeholderView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

// MARK: - FavouriteThreadsView

extension FavouriteThreadsViewController: FavouriteThreadsView {
    
    func updateTable() {
        tableView.reloadData()
        let shouldHidePlaceholder = !presenter.dataSource.isEmpty
        tableView.isHidden = !shouldHidePlaceholder
        placeholderView.isHidden = shouldHidePlaceholder
    }
}

// MARK: - UITableViewDataSource

extension FavouriteThreadsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavouriteThreadCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
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

extension FavouriteThreadsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectBoard(index: indexPath.row)
    }
}
