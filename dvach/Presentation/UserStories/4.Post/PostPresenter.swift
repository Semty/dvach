//
//  PostPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SafariServices
import DeepDiff

private extension Int {
    static let numberOfViewsForRate = 100
}

typealias Replies = [String: [String]]

protocol IPostPresenter {
    var adInsertingSemaphore: DispatchSemaphore { get }
    var dataSource: WriteLockableSynchronizedArray<PostPresenter.CellType> { get }
    var mediaViewControllerWasPresented: Bool { get set }
    
    func viewDidLoad()
    func refresh()
    func didTapFile(index: Int,
                    postIndex: Int,
                    imageViews: [UIImageView])
    func postCommentView(_ view: PostCommentViewContainer, didTapURL url: URL)
    func postCommentView(_ view: PostCommentViewContainer, didTapAnswerButton postNumber: String)
    func postCommentView(_ view: PostCommentViewContainer, didTapAnswersButton postNumber: String)
    func postCommentView(_ view: PostCommentViewContainer, didTapMoreButton button: UIView, postNumber: String)
}

final class PostPresenter {
    
    // Dependencies
    weak var view: (PostView & UIViewController)?
    private var router: IPostRouter
    private let dvachService = Locator.shared.dvachService()
    private let appSettingsStorage = Locator.shared.appSettingsStorage()
    
    // Semaphore for resolving the issue with ad inserting and data update
    public lazy var adInsertingSemaphore: DispatchSemaphore = {
        let semaphore = DispatchSemaphore(value: 0)
        semaphore.signal()
        return semaphore
    }()
    
    // Ad inserting queue
    private lazy var adInsertingQueue = DispatchQueue(label: "com.ruslantimchenko.adInsertingQueue",
                                                      qos: .utility)
    
    // Properties
    var dataSource = WriteLockableSynchronizedArray<CellType>()
    var mediaViewControllerWasPresented: Bool {
        get {
            return router.mediaViewControllerWasPresented
        }
        set {
            router.mediaViewControllerWasPresented = newValue
        }
    }

    private let boardIdentifier: String
    private let thread: ThreadShortInfo
    private var postNumber: String?
    private var posts = [Post]()
    private var replies = Replies()
    private var numberOfAds = 0
    private var adIndexPaths = [IndexPath]()
    
    // MARK: - Initialization
    
    init(router: IPostRouter, board: String, thread: ThreadShortInfo, postNumber: String?) {
        self.router = router
        self.boardIdentifier = board
        self.thread = thread
        self.postNumber = postNumber
    }
    
    // MARK: - Private
    
    private func loadPost(fullReload: Bool, completion: @escaping (WriteLockableSynchronizedArray<PostPresenter.CellType>, [Change<PostPresenter.CellType>]) -> Void, error: @escaping (Error) -> Void) {
        
        var postNum: Int?
        // Если тред обновляем, то нет смысла грузить весь тред, так что грузим только новые посты
        if !fullReload {
            postNum = posts.count + 1
        }
        dvachService.loadThreadWithPosts(board: boardIdentifier,
                                         threadNum: thread.number,
                                         postNum: postNum,
                                         location: nil)
        { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(var posts):
                // Если пришло 0 постов, то возвращаем ошибку
                if posts.count > 0 {
                    print("\nDATA UPDATE WAIT\n")
                    self.adInsertingSemaphore.wait()
                    print("\nDATA UPDATE CONTINUE\n")
                    
                    // Обнуляем все реплаи только в случае получения какой-то даты
                    self.replies = [:]

                    if !fullReload {
                        posts.insert(contentsOf: self.posts, at: 0)
                    }
                    var enrichedPosts = [Post]()
                    posts.forEach(self.updateReplies) // Приходится два раза пробегать по массиву с постами :(
                    let synchronizedDataSource = WriteLockableSynchronizedArray<CellType>()
                    for (index, item) in posts.enumerated() {
                        var post = item
                        post.rowIndex = index // Проставляем индекс здесь, чтобы он не сбился из-за рекламы
                        enrichedPosts.append(post)
                        let model = self.createPostViewModel(post: post)
                        synchronizedDataSource.append(.post(model))
                    }
                    
                    self.posts = enrichedPosts
                    
                    if !fullReload {
                        // Находим, какие ячейки изменились
                        let changes = diff(old: self.dataSource.array ?? [],
                                           new: synchronizedDataSource.array ?? [])
                        
                        completion(synchronizedDataSource, changes)
                    } else {
                        // Находим, какие ячейки изменились
                        let changes = diff(old: self.dataSource.array ?? [],
                                           new: synchronizedDataSource.array ?? [])
                        completion(synchronizedDataSource, changes)
                    }
                    
                } else {
                    error(NSError(domain: "Нет новых постов",
                                  code: 228,
                                  userInfo: nil))
                }
                
            case .failure(let receivedError):
                error(NSError(domain: receivedError.localizedDescription,
                              code: 1488,
                              userInfo: nil))
            }
        }
    }
    
    private func updateReplies(post: Post) {
        let parser = PostParser(text: post.comment)
        let repliesIds = parser.dvachLinkModels.repliesIdentifiers
        repliesIds.forEach {
            // Берем предыдущее значение массива реплаев
            var repliesArray = replies[$0] ?? []
            // Добавляем текущй номер поста
            repliesArray.append(post.number)
            // Перезаписываем массив реплаев для нужного номера поста
            replies[$0] = repliesArray
        }
    }
    
    private func createPostViewModel(post: Post) -> PostCommentViewModel {
        let headerViewModel = PostHeaderView.Model(title: post.name.finishHtmlToNormalString(),
                                                   subtitle: post.number,
                                                   number: post.rowIndex + 1)
        let imageURLs = post.files.map { $0.thumbnail }
        let postParser = PostParser(text: post.comment)
        let repliesCount = replies[post.number]?.count ?? 0
        let id = post.identifier
        
        return PostCommentViewModel(postNumber: post.number,
                                    headerModel: headerViewModel,
                                    date: post.date,
                                    text: postParser.attributedText,
                                    fileURLs: imageURLs,
                                    numberOfReplies: repliesCount,
                                    isAnswerHidden: true,
                                    isRepliesHidden: false,
                                    id: id)
    }
    
    private func scrollIndexPath(for dataSource: WriteLockableSynchronizedArray<CellType>) -> IndexPath? {
        guard let postNumber = postNumber else { return nil }
        var row = 0
        dataSource.enumerated().forEach {
            if $0.element.postNumber == postNumber {
                row = $0.offset
                return
            }
        }
 
        return IndexPath(row: row, section: 0)
    }
    
    private func showRateOfferIfNeeded() {
        let numberOfViews = appSettingsStorage.numberOfThreadViews
        appSettingsStorage.numberOfThreadViews = numberOfViews + 1
        if numberOfViews == .numberOfViewsForRate {
            view?.showRateController()
            Analytics.logEvent("RateAppShown", parameters: [:])
        }
    }
}

// MARK: - IPostPresenter

extension PostPresenter: IPostPresenter {
    
    func viewDidLoad() {
        showRateOfferIfNeeded()
        loadPost(fullReload: true,
                 completion: { [weak self] newDataSource, changes in
                guard let self = self else { return }
                let scrollIndexPath = self.scrollIndexPath(for: newDataSource)
                DispatchQueue.main.async {
                    self.view?.updateTable(changes: changes,
                                           scrollTo: scrollIndexPath,
                                           signalAdSemaphore: true,
                                           completion: { [weak self] in
                                            self?.dataSource = newDataSource
                    })
                }
        }) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.showPlaceholder(text: error.localizedDescription)
            }
        }

        Analytics.logEvent("PostsShown", parameters: [:])
    }
    
    func refresh() {
        postNumber = posts.last?.number
        
        loadPost(fullReload: false,
                 completion:
            { [weak self] newDataSource, changes in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.view?.endRefreshing(error: nil,
                                             changes: changes,
                                             signalAdSemaphore: true,
                                             completion: { [weak self] in
                                                self?.dataSource = newDataSource
                                                
                    })
                }
        }) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.endRefreshing(error: error,
                                         changes: [],
                                         signalAdSemaphore: true,
                                         completion: {})
            }
        }
    }
    
    func didTapFile(index: Int,
                    postIndex: Int,
                    imageViews: [UIImageView]) {
        let mediaViewerSource = MediaViewerManager.Source(imageViews: imageViews,
                                                          files: posts[postIndex].files,
                                                          imageIndex: index)

        router.presentMediaController(source: mediaViewerSource)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapURL url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        let safariVC = SFSafariViewController(url: url)
        self.view?.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self.view
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapAnswerButton postNumber: String) {
        router.postCommentView(view, didTapAnswerButton: postNumber)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapAnswersButton postNumber: String) {
        router.postCommentView(view,
                               didTapAnswersButton: postNumber,
                               posts: posts,
                               replies: replies,
                               board: boardIdentifier,
                               thread: thread)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapMoreButton button: UIView, postNumber: String) {
        guard let postIndex = posts.firstIndex(where: { $0.number == postNumber }) else { return }
        let post = posts[postIndex]
        router.postCommentView(view,
                               didTapMoreButton: button,
                               post: post,
                               thread: thread,
                               boardId: boardIdentifier,
                               row: post.rowIndex)
    }
}
