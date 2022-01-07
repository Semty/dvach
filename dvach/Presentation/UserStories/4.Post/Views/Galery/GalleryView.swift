//
//  GalleryView.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Nuke

typealias GalleryCell = CollectionViewContainerCellBase<GalleryView>

final class GalleryView: UIView, ConfigurableView, ReusableView, PressStateAnimatable {
    
    struct Model {
        let imageURL: String
        let type: FileType
        let isSafeMode: Bool
    }
    
    // UI
    public lazy var imageView = UIImageView()
    private lazy var typeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .n10WhiteIsh
        view.layer.cornerRadius = 4
        return view
    }()
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setup() {
        enablePressStateAnimation()
        makeRoundedByCornerRadius(.radius10)
        
        addSubview(imageView)
        imageView.addSubview(typeContainer)
        typeContainer.addSubview(typeLabel)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        typeContainer.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(4)
        }
        typeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.leading.trailing.equalToSuperview().inset(4)
        }
        
        imageView.makeRoundedByCornerRadius(.radius10)
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: GalleryView.Model) {
        typeLabel.text = model.type.description
        imageView.loadImage(url: model.imageURL,
                            defaultImage: UIImage(named: "placeholder"),
                            placeholder: nil,
                            transition: true,
                            checkNSFW: true,
                            isSafeMode: model.isSafeMode)
        layoutIfNeeded()
    }
    
    // MARK: - ReusableView
    
    func prepareForReuse() {
        imageView.image = nil
        typeLabel.text = nil
    }
}
