//
//  BoardWithThreadsViewController.swift
//  dvach
//
//  Created by Ruslan Timchenko on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit

private extension CGFloat {
    static let tableViewContentInset: CGFloat = 16
    static let threadWithImageCellHeight: CGFloat = 185
    static let threadWithoutImageCellHeight: CGFloat = 170
}

protocol BoardWithThreadsView: AnyObject {
    func showNSFWBanner()
    func updateNavigationBar()
    func dataWasLoaded()
    func dataWasNotLoaded()
}

final class BoardWithThreadsViewController: UIViewController {
    
    // Dependencies
    private let presenter: IBoardWithThreadsPresenter
    
    // UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ThreadWithImageCell.self)
        tableView.register(ThreadWithoutImageCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: .tableViewContentInset,
                                       left: 0,
                                       bottom: 0,
                                       right: 0)
        tableView.alpha = 0.0
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshControlDidPull),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var skeleton = SkeletonThreadView.fromNib()
    private var popRecognizer: SwipeToBackRecognizer?
    
    // Timing Variables
    private var timeStart = CFAbsoluteTime()
    private var timeDiff: CFAbsoluteTime {
        return CFAbsoluteTimeGetCurrent() - timeStart
    }
    
    // MARK: - Initialization
    
    init(boardID: String) {
        let presenter = BoardWithThreadsPresenter(boardID: boardID)
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setupPopRecognizer()
        updateNavigationItem()
        skeleton.update(state: .active)
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(skeleton)
        skeleton.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupPopRecognizer() {
        guard let controller = navigationController else { return }
        popRecognizer = SwipeToBackRecognizer(controller: controller)
        navigationController?.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
    
    private func updateNavigationItem() {
        let item: UIBarButtonItem
        if presenter.isFavourite {
            item = .menuButton(self,
                               action: #selector(removeFromFavourites),
                               imageName: "bookmark")
        } else {
            item = .menuButton(self,
                               action: #selector(addToFavourites),
                               imageName: "empty_bookmark")
        }
        item.tintColor = .n7Blue
        navigationItem.rightBarButtonItem = item
    }
    
    private func endRefreshing() {
        if self.refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    private func updateTable() {
        updateNavigationItem()
        var indexPaths = [IndexPath]()
        for row in 0..<presenter.dataSource.count {
            indexPaths.append(IndexPath(row: row, section: 0))
        }
        
        if tableView.numberOfRows(inSection: 0).isZero {
            tableView.beginUpdates()
            tableView.insertRows(at: indexPaths,
                                 with: .fade)
            tableView.endUpdates()
        } else {
            tableView.setContentOffset(tableView.contentOffset, animated: false)
            tableView.beginUpdates()
            tableView.reloadRows(at: indexPaths,
                                 with: .fade)
            tableView.endUpdates()
        }
        
        if !skeleton.isHidden {
            skeleton.update(state: .nonactive)
            view.skeletonAnimation(skeletonView: skeleton, mainView: tableView)
        }
        
        endRefreshing()
    }
    
    // MARK: - Actions
    
    @objc private func addToFavourites() {
        presenter.addToFavouritesDidTap()
    }
    
    @objc private func removeFromFavourites() {
        presenter.removeFromFavouritesDidTap()
    }
    
    @objc private func refreshControlDidPull() {
        timeStart = CFAbsoluteTimeGetCurrent()
        presenter.refreshControllDidPull()
    }
}

// MARK: - BoardWithThreadsView

extension BoardWithThreadsViewController: BoardWithThreadsView {
    
    func showNSFWBanner() {
        let vc = BannerViewController()
        vc.delegate = self
        let attributes = vc.getAnimationAttributes(presentingVC: self)
        SwiftEntryKit.display(entry: vc, using: attributes)
    }
    
    func updateNavigationBar() {
        updateNavigationItem()
    }
    
    func dataWasNotLoaded() {
        endRefreshing()
    }
    
    func dataWasLoaded() {
        let timeDiff = 1.0 - self.timeDiff
        
        if timeDiff > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeDiff) { [weak self] in
                guard let self = self else { return }
                self.updateTable()
            }
        } else {
            updateTable()
        }
    }
}

// MARK: - UITableViewDataSource

extension BoardWithThreadsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = presenter.dataSource[safeIndex: indexPath.row] else { return UITableViewCell() }
        switch model {
        case .withImage(let threadWithImageModel):
            let cell: ThreadWithImageCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: threadWithImageModel)
            return cell
        case .withoutImage(let threadWithoutImageModel):
            let cell: ThreadWithoutImageCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: threadWithoutImageModel)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension BoardWithThreadsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model = presenter.dataSource[safeIndex: indexPath.row] else { return .zero }
        switch model {
        case .withImage: return .threadWithImageCellHeight
        case .withoutImage: return .threadWithoutImageCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let model = presenter.dataSource[safeIndex: indexPath.row] else { return .zero }
        switch model {
        case .withImage: return .threadWithImageCellHeight
        case .withoutImage: return .threadWithoutImageCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCell(index: indexPath.row)
    }
}

// MARK: - BannerViewControllerDelegate

extension BoardWithThreadsViewController: BannerViewControllerDelegate {
    
    func didTapAgree() {
        presenter.userDidAgreeWithNSFWTerms()
    }
    
    func didTapDisagree() {}

}
