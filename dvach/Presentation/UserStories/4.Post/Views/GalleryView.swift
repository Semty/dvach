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
    }
    
    // UI
    public lazy var imageView = UIImageView()
    
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
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.makeRoundedByCornerRadius(.radius10)
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: GalleryView.Model) {
        imageView.loadImage(url: model.imageURL,
                            defaultImage: UIImage(named: "placeholder"),
                            transition: true)
    }
    
    // MARK: - ReusableView
    
    func prepareForReuse() {
        imageView.image = nil
    }
}
