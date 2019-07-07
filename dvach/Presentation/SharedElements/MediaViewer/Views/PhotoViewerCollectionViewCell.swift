//
//  PhotoViewerCollectionViewCell.swift
//  dvach
//
//  Created by Ruslan Timchenko on 20/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class PhotoViewerCollectionViewCell: DTPhotoCollectionViewCell {
    
    // UI
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
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
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.top.equalToSuperview().inset(CGFloat.inset16)
        }
    }
}
