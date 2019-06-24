//
//  PostViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol PostView: AnyObject {
    func updateTable(scrollTo rowIndex: Int)
}

final class PostViewController: UIViewController {
    
    // Dependencies
    private let presenter: IPostViewPresenter
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // UI
    private lazy var closeButton = componentsFactory.createCloseButton(nil, nil) { [weak self] in
        self?.dismiss(animated: true)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(PostCommentCell.self)
        tableView.register(ContextAdCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.alpha = 0.0
        
        return tableView
    }()
    
    private lazy var skeleton = SkeletonPostView.fromNib()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        skeleton.update(state: .active)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { $0.top.trailing.equalToSuperview().inset(CGFloat.inset16) }
        
        view.addSubview(skeleton)
        skeleton.snp.makeConstraints { $0.edges.equalToSuperview() }
        
    }
}

// MARK: - PostView

extension PostViewController: PostView {
    
    func updateTable(scrollTo rowIndex: Int) {
        tableView.reloadData()
        skeleton.update(state: .nonactive)
        view.skeletonAnimation(skeletonView: skeleton, mainView: tableView)
        
        if rowIndex > 0 {
            tableView.scrollToRow(at: IndexPath(row: rowIndex, section: 0),
                                  at: .middle,
                                  animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension PostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch presenter.dataSource[indexPath.row] {
        case .post(let viewModel):
            let cell: PostCommentCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.prepareForReuse()
            cell.configure(with: viewModel)
            cell.containedView.delegate = self
            if indexPath.row == presenter.dataSource.count - 1 {
                cell.containedView.removeBottomSeparator()
            }
            
            return cell
        case .ad(let adView):
            let cell: ContextAdCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.containedView.addSubview(adView)
            adView.snp.makeConstraints { $0.edges.equalToSuperview() }
            return cell
        }
    }
}

// MARK: - PostCommentViewDelegate

extension PostViewController: PostCommentViewDelegate {
    
    func postCommentView(_ view: PostCommentView,
                         didTapFile index: Int,
                         postIndex: Int,
                         imageViews: [UIImageView]) {
        presenter.didTapFile(index: index,
                             postIndex: postIndex,
                             imageViews: imageViews)
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
