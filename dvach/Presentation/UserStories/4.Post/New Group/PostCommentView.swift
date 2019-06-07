//
//  PostCommentView.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

typealias PostCommentCell = TableViewContainerCellBase<PostCommentView>

final class PostCommentView: UIView, ConfigurableView, ReusableView, SeparatorAvailable {
    
    struct Model {
        let headerModel: PostHeaderView.Model
        let date: String
        let text: String
        let imageURLs: [String]
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
        
        return HorizontalList<GalleryCell>(configuration: configuration)
    }()
    
    // Дата
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .n2Gray
        label.font = UIFont.systemFont(ofSize: 10)
        label.snp.makeConstraints { $0.height.equalTo(30) }
        return label
    }()
    private lazy var dateView: UIView = {
        let view = UIView()
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CGFloat.inset16)
            $0.top.bottom.trailing.equalToSuperview()
        }
        return view
    }()
    
    // Текст
    private lazy var text: UILabel = {
        let label = UILabel()
        label.textColor = .n1Gray
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 0
        return label
    }()
    private lazy var textView: UIView = {
        let view = UIView()
        view.addSubview(text)
        text.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CGFloat.inset16)
            $0.top.bottom.trailing.equalToSuperview()
        }
        return view
    }()
    
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
    }
    
    private func setupGallery() {
        
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: PostCommentView.Model) {
        headerView.configure(with: model.headerModel)
        dateLabel.text = model.date
        text.text = model.text
        
        gallery.isHidden = model.imageURLs.isEmpty
        if !model.imageURLs.isEmpty {
            let galleryModels = model.imageURLs.map { GalleryView.Model(imageURL: $0) }
            gallery.update(dataSource: galleryModels)
        }
    }
}
