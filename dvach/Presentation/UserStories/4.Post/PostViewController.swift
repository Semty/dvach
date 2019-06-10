//
//  PostViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol PostView: AnyObject {
    func updateTable()
}

final class PostViewController: UIViewController {
    
    // Dependencies
    private let presenter: IPostViewPresenter
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // UI
    private lazy var closeButton = componentsFactory.createCloseButton { [weak self] in
        self?.dismiss(animated: true)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCommentCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Initialization
    
    init(presenter: IPostViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
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
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { $0.top.trailing.equalToSuperview().inset(CGFloat.inset16) }
    }
}

// MARK: - PostView

extension PostViewController: PostView {
    
    func updateTable() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension PostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostCommentCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.prepareForReuse()
        let viewModel = presenter.viewModels[indexPath.row]
        cell.configure(with: viewModel)
        cell.containedView.delegate = self
        if indexPath.row == presenter.viewModels.count - 1 {
            cell.containedView.removeBottomSeparator()
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension PostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter.didSelectBoard(index: indexPath.row)
    }
}

// MARK: - PostCommentViewDelegate

extension PostViewController: PostCommentViewDelegate {
    
    func postCommentView(_ view: PostCommentView, didTapFile index: Int) {
        presenter.postCommentView(view, didTapFile: index)
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
