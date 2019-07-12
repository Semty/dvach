//
//  PostCommentWithMediaView.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Nantes
import Appodeal

typealias PostCommentWithMediaCell = TableViewContainerCellBase<PostCommentWithMediaView>

struct PostCommentViewModel {
    let postNumber: String
    let headerModel: PostHeaderView.Model
    let date: String
    let text: NSAttributedString
    let fileURLs: [String]
    let numberOfReplies: Int
    let isAnswerHidden: Bool
    let isRepliesHidden: Bool
}

protocol PostCommentViewContainer: UIView {
    var delegate: PostCommentViewDelegate? { get }
    func configure(with model: PostCommentViewModel)
}

protocol PostCommentViewDelegate: AnyObject {
    func postCommentView(_ view: PostCommentViewContainer,
                         didTapFile index: Int,
                         postIndex: Int,
                         imageViews: [UIImageView])
    func postCommentView(_ view: PostCommentViewContainer, didTapURL url: URL)
    func postCommentView(_ view: PostCommentViewContainer, didTapAnswerButton postNumber: String)
    func postCommentView(_ view: PostCommentViewContainer, didTapAnswersButton postNumber: String)
    func postCommentView(_ view: PostCommentViewContainer, didTapMoreButton button: UIView, postNumber: String)
}

final class PostCommentWithMediaView: UIView, ConfigurableView, ReusableView, SeparatorAvailable, PostCommentViewContainer {
    
    // Dependencies
    weak var delegate: PostCommentViewDelegate?
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // Properties
    private var postNumber = ""
    private var indexNumber: Int {
        return headerView.serialNumber - 1
    }
    
    // UI
    private lazy var stackView = UIStackView(axis: .vertical)
    private lazy var headerView = PostHeaderView.fromNib()
    private lazy var gallery: HorizontalList<GalleryCell> = {
        let configuration = HorizontalListConfiguration(itemSize: CGSize(width: 80, height: 80),
                                                        shadow: nil,
                                                        height: 80,
                                                        itemSpacing: .inset8,
                                                        insets: .defaultInsets)
        let list = HorizontalList<GalleryCell>(configuration: configuration)
        list.selectionHandler = { [weak self] index, cells in
            guard let self = self else { return }
            guard let galleryCells = cells as? [GalleryCell] else { return }
            let imageViews = galleryCells.map { $0.containedView.imageView }
            
            self.delegate?.postCommentView(self,
                                           didTapFile: index.row,
                                           postIndex: self.indexNumber,
                                           imageViews: imageViews)
        }
        return list
    }()
    
    // Дата
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .n2Gray
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var dateView: UIView = {
        let view = UIView()
        view.addSubview(dateLabel)
        view.snp.makeConstraints { $0.height.equalTo(16) }
        dateLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(CGFloat.inset16)
            $0.top.bottom.equalToSuperview()
        }
        return view
    }()
    
    // Текст
    private lazy var text: NantesLabel = {
        let label = NantesLabel()
        label.textColor = .n1Gray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.delegate = self
        return label
    }()
    
    private lazy var textView: UIView = {
        let view = UIView()
        view.addSubview(text)
        text.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(CGFloat.inset16)
            $0.top.bottom.equalToSuperview()
        }
        return view
    }()
    
    // Кнопки
    private lazy var buttonsView: PostCommentButtonsView = {
        let view = PostCommentButtonsView.fromNib()
        view.snp.makeConstraints { $0.height.equalTo(50) }
        
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupUI() {
        addBottomSeparator(with: .defaultStyle)
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(gallery)
        stackView.addArrangedSubview(dateView)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(componentsFactory.createEmptyView(height: .inset8))
        stackView.addArrangedSubview(buttonsView)
        stackView.addArrangedSubview(componentsFactory.createEmptyView(height: .inset8))
        
        buttonsView.delegate = self
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = PostCommentViewModel
    
    func configure(with model: ConfigurationModel) {
        postNumber = model.postNumber
        headerView.configure(with: model.headerModel)
        dateLabel.text = model.date
        text.attributedText = model.text
        
        if !model.fileURLs.isEmpty {
            let galleryModels = model.fileURLs.map { GalleryView.Model(imageURL: $0) }
            gallery.update(dataSource: galleryModels)
        }
        
        let answerModel = model.isAnswerHidden ? nil : VerticalOvalButton.Model(color: .n1Gray,
                                                                                icon: UIImage(named: "answer"),
                                                                                text: nil)
        let hideReplies = model.isRepliesHidden || model.numberOfReplies == 0
        let answersModel = hideReplies ? nil : VerticalOvalButton.Model(color: .n4Red,
                                                                                  icon: UIImage(named: "answers"),
                                                                                  text: "\(model.numberOfReplies)")
        let moreModel = VerticalOvalButton.Model(color: .n9LightGreen, icon: UIImage(named: "more"), text: nil)
        let buttonsModel = PostCommentButtonsView.Model(answerButtonModel: answerModel,
                                                        answersButtonModel: answersModel,
                                                        moreButtonModel: moreModel)
        buttonsView.configure(with: buttonsModel)
    }
    
    // MARK: - ReusableView
    
    func prepareForReuse() {
        headerView.prepareForReuse()
        dateLabel.text = nil
        text.attributedText = nil
    }
}

// MARK: - NantesLabelDelegate

extension PostCommentWithMediaView: NantesLabelDelegate {
    
    func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        delegate?.postCommentView(self, didTapURL: link)
    }
}

// MARK: - PostCommentButtonsViewDelegate

extension PostCommentWithMediaView: PostCommentButtonsViewDelegate {
    
    func answerButtonDidTap() {
        Analytics.logEvent("AnswerButtonDidTap", parameters: [:])
        delegate?.postCommentView(self, didTapAnswerButton: postNumber)
    }
    
    func answersButtonDidTap() {
        Analytics.logEvent("AnswersButtonDidTap", parameters: [:])
        delegate?.postCommentView(self, didTapAnswersButton: postNumber)
    }
    
    func moreButtonDidTap(_ button: UIView) {
        Analytics.logEvent("MoreButtonDidTap", parameters: [:])
        delegate?.postCommentView(self, didTapMoreButton: button, postNumber: postNumber)
    }
}
