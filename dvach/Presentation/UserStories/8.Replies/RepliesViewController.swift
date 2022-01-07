//
//  RepliesViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SafariServices

protocol RepliesView: AnyObject, SFSafariViewControllerDelegate {
    func updateTable()
}

final class RepliesViewController: UIViewController {
    
    // Dependencies
    private let presenter: IRepliesPresenter
    
    // UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCommentWithMediaCell.self)
        tableView.register(PostCommentWithoutMediaCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private var heightDictionary: [Int : CGFloat] = [:]
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideStatusBar(false, animation: true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
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
        
        if viewModel.files.isEmpty {
            let cell: PostCommentWithoutMediaCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.prepareForReuse()
            cell.configure(with: viewModel)
            cell.containedView.delegate = self
            if indexPath.row == presenter.dataSource.count - 1 {
                cell.containedView.removeBottomSeparator()
            }
            return cell
        } else {
            let cell: PostCommentWithMediaCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.prepareForReuse()
            cell.configure(with: viewModel)
            cell.containedView.delegate = self
            if indexPath.row == presenter.dataSource.count - 1 {
                cell.containedView.removeBottomSeparator()
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension RepliesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableView.automaticDimension
    }
}

// MARK: - PostCommentViewDelegate

extension RepliesViewController: PostCommentViewDelegate {
    
    func postCommentView(_ view: PostCommentViewContainer,
                         didTapFile index: Int,
                         postIndex: Int,
                         imageViews: [UIImageView]) {
        presenter.didTapFile(index: index,
                             postIndex: postIndex,
                             imageViews: imageViews)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapURL url: URL) {
        presenter.postCommentView(view, didTapURL: url)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapAnswerButton postNumber: String) {
        presenter.postCommentView(view, didTapAnswerButton: postNumber)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapAnswersButton postNumber: String) {
        presenter.postCommentView(view, didTapAnswersButton: postNumber)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapMoreButton button: UIView, postNumber: String) {
        presenter.postCommentView(view, didTapMoreButton: button, postNumber: postNumber)
    }
}

// MARK: - SFSafariViewControllerDelegate

extension RepliesViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
