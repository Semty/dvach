//
//  SinglePostViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 16/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Appodeal
import SafariServices

protocol SinglePostView: AnyObject, SFSafariViewControllerDelegate {
    func configure(model: PostCommentViewModel)
    func addAdvertisingView(_ view: AdView)
}

final class SinglePostViewController: UIViewController {
    
    // Dependencies
    private let presenter: ISinglePostPresenter
    private let componentsFactory = Locator.shared.componentsFactory()

    // UI
    private lazy var stackView = componentsFactory.createStackViewContainer()
    private lazy var button: BottomButton = {
        let button = BottomButton()
        let model = BottomButton.Model(text: "Открыть в треде",
                                       backgroundColor: .n7Blue, textColor: .white)
        button.configure(with: model)
        button.enablePressStateAnimation { [weak self] in
            self?.presenter.didTapOpenThread()
        }
        return button
    }()
    private lazy var postView: PostCommentViewContainer = {
        if presenter.postFilesIsEmpty {
            let postView = PostCommentWithoutMediaView()
            postView.removeBottomSeparator()
            postView.delegate = self
            
            return postView
        } else {
            let postView = PostCommentWithMediaView()
            postView.removeBottomSeparator()
            postView.delegate = self
            
            return postView
        }
    }()
    private lazy var closeButton = componentsFactory.createCloseButton(style: .dismiss,
                                                                       imageColor: nil,
                                                                       backgroundColor: nil) { [weak self] in
        self?.dismiss(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        hideStatusBar(true, animation: true)
        return false
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
        stackView.contentInset.top = view.safeAreaInsets.top
        button.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom + CGFloat.inset8)
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.addSubview(stackView)
        extendedLayoutIncludesOpaqueBars = true
        stackView.contentInset.bottom = 60
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        stackView.addView(postView)
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { $0.top.trailing.equalToSuperview().inset(CGFloat.inset16) }
        
        view.addSubview(button)
        let inset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : .inset16
        button.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(inset)
            $0.bottom.equalToSuperview().inset(CGFloat.inset8)
        }
    }
}

// MARK: - SinglePostView

extension SinglePostViewController: SinglePostView {
    
    func configure(model: PostCommentViewModel) {
        postView.configure(with: model)
    }
    
    func addAdvertisingView(_ view: AdView) {
        view.alpha = 0.0
        stackView.addView(view)
        UIView.animate(withDuration: 0.75) {
            view.alpha = 1.0
        }
    }
}

// MARK: - PostCommentViewDelegate

extension SinglePostViewController: PostCommentViewDelegate {
    
    func postCommentView(_ view: PostCommentViewContainer,
                         didTapFile index: Int,
                         postIndex: Int,
                         imageViews: [UIImageView]) {
        presenter.didTapFile(index: index, postIndex: postIndex, imageViews: imageViews)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapURL url: URL) {
        presenter.postCommentView(view, didTapURL: url)
    }
    
    func postCommentView(_ view: PostCommentViewContainer, didTapAnswerButton postNumber: String) {}
    
    func postCommentView(_ view: PostCommentViewContainer, didTapAnswersButton postNumber: String) {}
    
    func postCommentView(_ view: PostCommentViewContainer, didTapMoreButton button: UIView, postNumber: String) {
        presenter.postCommentView(view, didTapMoreButton: button, postNumber: postNumber)
    }
}

// MARK: - SFSafariViewControllerDelegate

extension SinglePostViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
