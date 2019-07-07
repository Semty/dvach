//
//  RepliesViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol RepliesView: AnyObject {
    func updateTable()
}

final class RepliesViewController: UIViewController {
    
    // Dependencies
    private let presenter: IRepliesPresenter
    
    // UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(PostCommentCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    // MARK: - Initialization
    
    init(presenter: IRepliesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackBarButton()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupBackBarButton() {
        let backItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        backItem.tintColor = .n1Gray
        navigationItem.backBarButtonItem = backItem
    }
}

// MARK: - RepliesView

extension RepliesViewController: RepliesView {
    
    func updateTable() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension RepliesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = presenter.dataSource[indexPath.row]
        let cell: PostCommentCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.prepareForReuse()
        cell.configure(with: viewModel)
        cell.containedView.delegate = self
        if indexPath.row == presenter.dataSource.count - 1 {
            cell.containedView.removeBottomSeparator()
        }
        return cell
    }
}

// MARK: - PostCommentViewDelegate

extension RepliesViewController: PostCommentViewDelegate {
    
    func postCommentView(_ view: PostCommentView,
                         didTapFile index: Int,
                         postIndex: Int,
                         imageViews: [UIImageView]) {
        presenter.didTapFile(index: index,
                             postIndex: postIndex,
                             imageViews: imageViews)
    }
    
    func postCommentView(_ view: PostCommentView, didTapURL url: URL) {
        presenter.postCommentView(view, didTapURL: url)
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int) {
        presenter.postCommentView(view, didTapAnswerButton: postNumber)
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int) {
        presenter.postCommentView(view, didTapAnswersButton: postNumber)
    }
    
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int) {
        presenter.postCommentView(view, didTapMoreButton: postNumber)
    }
}
