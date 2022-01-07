//
//  PostViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import KafkaRefresh
import SafariServices
import DeepDiff
import StoreKit

protocol PostView: AnyObject, SFSafariViewControllerDelegate {
    func updateTable(changes: [Change<PostPresenter.CellType>],
                     scrollTo indexPath: IndexPath?,
                     signalAdSemaphore: Bool,
                     completion: () -> Void)
    func showPlaceholder(text: String)
    func endRefreshing(error: Error?,
                       changes: [Change<PostPresenter.CellType>],
                       signalAdSemaphore: Bool,
                       completion: @escaping () -> Void)
    func showRateController()
    var lastVisibleRow: Int { get }
}

final class PostViewController: UIViewController {
    
    // Dependencies
    private var presenter: IPostPresenter
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // Properties
    private var startRefreshTime = Date().timeIntervalSince1970
    private var deltaRefreshTime: TimeInterval {
        return Date().timeIntervalSince1970 - startRefreshTime
    }
    private var closeButtonStyle: CloseButton.Style {
        return (navigationController?.viewControllers.count ?? 0 > 1) ? .pop : .dismiss
    }
    private var visibleRows = [IndexPath]()
    
    // UI
    private lazy var closeButton = componentsFactory.createCloseButton(style: closeButtonStyle,
                                                                       imageColor: nil,
                                                                       backgroundColor: nil) { [weak self] in
        guard let self = self else { return }
        switch self.closeButtonStyle {
        case .pop: self.navigationController?.popViewController(animated: true)
        case .dismiss: self.dismiss(animated: true, completion: nil)
        }
    }
    
    private lazy var scrollButton: ScrollButton = {
        let button = ScrollButton()
        button.delegate = self
        button.isHidden = true
        return button
    }()
    
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
        tableView.alpha = 0.0
        tableView.footRefreshControl = refreshControll
        
        return tableView
    }()
    
    private var shouldShowScrollButton: Bool {
        // Показываем только если контента больше, чем 3 экрана
        return (UIScreen.main.bounds.height * 3) > tableView.contentSize.height
    }
    
    private lazy var refreshControll: KafkaReplicatorFooter = {
        let refresh = KafkaReplicatorFooter()
        refresh.themeColor = .n7Blue
        refresh.refreshHandler = { [weak self] in
            self?.refreshThread()
        }
        return refresh
    }()
    private lazy var placeholder = PlaceholderView()
    private lazy var skeleton = SkeletonPostView.fromNib()
    private var popRecognizer: SwipeToBackRecognizer?
    
    private var heightDictionary: [Int : CGFloat] = [:]

    override var prefersStatusBarHidden: Bool {
        hideStatusBar(true, animation: true)
        return false
    }
    
    // MARK: - Initialization
    
    init(presenter: IPostPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackBarButton()
        setupPopRecognizer()
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        skeleton.update(state: .active)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        presenter.mediaViewControllerWasPresented = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !presenter.mediaViewControllerWasPresented {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        scrollButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(CGFloat.inset16 + view.safeAreaInsets.bottom)
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.contentInset.bottom = 50
        
        view.addSubview(skeleton)
        skeleton.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(placeholder)
        placeholder.snp.makeConstraints { $0.edges.equalToSuperview() }
        placeholder.isHidden = true
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(CGFloat.inset16)
            $0.top.equalToSuperview().inset(CGFloat.inset40)
        }
        
        view.addSubview(scrollButton)
        scrollButton.snp.makeConstraints { $0.bottom.trailing.equalToSuperview().inset(CGFloat.inset16) }
    }
    
    private func setupBackBarButton() {
        let backItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        backItem.tintColor = .n1Gray
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setupPopRecognizer() {
        guard closeButtonStyle == .pop, let controller = navigationController else { return }
        popRecognizer = SwipeToBackRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
    
    private func hideSkeleton() {
        skeleton.update(state: .nonactive)
        view.skeletonAnimation(skeletonView: skeleton, mainView: tableView)
    }
    
    private func showNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func refreshThread() {
        startRefreshTime = Date().timeIntervalSince1970
        presenter.refresh()
    }
}

// MARK: - PostView

extension PostViewController: PostView {
    
    var lastVisibleRow: Int {
        return tableView.indexPathsForVisibleRows?.last?.row ?? 0
    }
    
    func updateTable(changes: [Change<PostPresenter.CellType>],
                     scrollTo indexPath: IndexPath?,
                     signalAdSemaphore: Bool,
                     completion: () -> Void) {
        
        tableView.reload(changes: changes,
                         section: 0,
                         insertionAnimation: .fade,
                         deletionAnimation: .fade,
                         replacementAnimation: .fade,
                         updateData: completion) { [weak self] _ in
                            if signalAdSemaphore {
                                self?.presenter.adInsertingSemaphore.signal()
                                print("\nUPDATE TABLE SIGNAL\n")
                            }
        }
        
        if let indexPath = indexPath, indexPath.row > 0 {
            tableView.scrollToRow(at: indexPath,
                                  at: .middle,
                                  animated: false)
        }
        hideSkeleton()
        scrollButton.isHidden = shouldShowScrollButton
    }
    
    func showPlaceholder(text: String) {
        placeholder.configure(with: text)
        placeholder.isHidden = false
        hideSkeleton()
    }
    
    func showRateController() {
        SKStoreReviewController.requestReview()
    }
    
    func endRefreshing(error: Error?,
                       changes: [Change<PostPresenter.CellType>],
                       signalAdSemaphore: Bool,
                       completion: @escaping () -> Void) {
        let alertString: String
        var newPostsNumber = 0
        let signalAdSemaphore: Bool
        
        changes.forEach { change in
            switch change {
            case .insert: newPostsNumber += 1
            case .delete, .replace, .move: break
            }
        }
        
        if let error = error {
            alertString = (error as NSError).domain
            signalAdSemaphore = false
        } else {
            alertString = "\(newPostsNumber) \(String(describing: newPostsNumber.rightWordForNew())) \(String(describing: newPostsNumber.rightWordForPostsCount()))"
            signalAdSemaphore = true
        }

        if deltaRefreshTime < 1.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                if newPostsNumber > 0 {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                self?.refreshControll.endRefreshing(withAlertText: alertString) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        self?.updateTable(changes: changes,
                                          scrollTo: nil,
                                          signalAdSemaphore: signalAdSemaphore,
                                          completion: completion)
                    }
                }
            }
        } else {
            if newPostsNumber > 0 {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            refreshControll.endRefreshing(withAlertText: alertString) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                    self?.updateTable(changes: changes,
                                      scrollTo: nil,
                                      signalAdSemaphore: signalAdSemaphore,
                                      completion: completion)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension PostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = presenter.dataSource[indexPath.row] {
            switch data {
            case .post(let viewModel):
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
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate

extension PostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > 0 else { return }
        let offset = scrollView.contentSize.height - (scrollView.bounds.height / 2) - scrollView.contentOffset.y
        var direction: ScrollButton.Direction = .down
        
        // Размер ячейки с рекламой 250
        // Поэтому к оффсету прибавляем половину высоты, чтобы стрелка не делала лишних движений
        if (scrollView.contentSize.height / 2) > offset - 125 {
            direction = .up
        } else if (scrollView.contentSize.height / 2) < offset + 125 {
            direction = .down
        }
        scrollButton.change(direction: direction)
    }
}

// MARK: - PostCommentViewDelegate

extension PostViewController: PostCommentViewDelegate {
    
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
        showNavigation()
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapMoreButton button: UIView, postNumber: String) {
        presenter.postCommentView(view, didTapMoreButton: button, postNumber: postNumber)
    }
}

// MARK: - SFSafariViewControllerDelegate

extension PostViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ScrollButtonDelegate

extension PostViewController: ScrollButtonDelegate {
    
    func scrollButtonDidTapped() {
        switch scrollButton.currentDirection {
        case .down:
            let indexPath = IndexPath(item: presenter.dataSource.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        case .up:
            let indexPath = IndexPath(item: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
