//
//  SinglePostViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 16/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol SinglePostView: AnyObject {
    func configure(model: PostCommentView.Model)
}

final class SinglePostViewController: UIViewController {
    
    // Dependencies
    private let presenter: ISinglePostPresenter
    private let componentsFactory = Locator.shared.componentsFactory()

    // UI
    private lazy var stackView = componentsFactory.createStackViewContainer()
    private lazy var postView: PostCommentView = {
        let postView = PostCommentView()
        postView.removeBottomSeparator()
        postView.delegate = self
        
        return postView
    }()
    private lazy var closeButton = componentsFactory.createCloseButton { [weak self] in
        self?.dismiss(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Initialization
    
    init(post: Post) {
        let presenter = SinglePostPresenter(post: post)
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
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
//        stackView.contentInset.top = view.safeAreaInsets.top
        //.snp.updateConstraints { $0.top.equalToSuperview().offset(view.safeAreaInsets.top) }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        stackView.addView(postView)

        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { $0.top.trailing.equalToSuperview().inset(CGFloat.inset16) }
    }
}

// MARK: - SinglePostView

extension SinglePostViewController: SinglePostView {
    
    func configure(model: PostCommentView.Model) {
        postView.configure(with: model)
    }
}

// MARK: - PostCommentViewDelegate

extension SinglePostViewController: PostCommentViewDelegate {
    
    func postCommentView(_ view: PostCommentView, didTapFile index: Int) {
        
    }
    
    func postCommentView(_ view: PostCommentView, didTapAnswerButton postNumber: Int) {}
    
    func postCommentView(_ view: PostCommentView, didTapAnswersButton postNumber: Int) {}
    
    func postCommentView(_ view: PostCommentView, didTapMoreButton postNumber: Int) {
        presenter.postCommentView(view, didTapMoreButton: postNumber)
    }
}
