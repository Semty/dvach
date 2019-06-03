//
//  CollectionViewContainerCellBase.swift
//  dvach
//
//  Created by Kirill Solovyov on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class CollectionViewContainerCellBase <T: UIView>: UICollectionViewCell, ConfigurableView where T: ConfigurableView, T: ReusableView {
    
    public private(set) lazy var containedView: T = T.isLoadableFromNib() ? T.fromNib() : T(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.tag = 103103
        contentView.addSubview(containedView)
        containedView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containedView.prepareForReuse()
    }
    
    // MARK: - ConfigurableView
    
    func configure(with model: T.ConfigurationModel) {
        containedView.configure(with: model)
    }
}

