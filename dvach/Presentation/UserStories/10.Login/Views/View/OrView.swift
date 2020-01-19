//
//  OrView.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 20.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

final class OrView: UIView {

    // UI
    private lazy var label: UILabel = {
        let label = UILabel()
//        label.font = AppConstants.Font.regular(size: 14)
//        label.textColor = Theme.current.awesomeBlackColor
        label.textAlignment = .center
//        label.text = AppConstants.Strings.Login.or
        return label
    }()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = AppConstants.Images.Login.line
        imageView.snp.makeConstraints {
            $0.width.equalTo(CGFloat.lineWidth)
            $0.height.equalTo(CGFloat.lineHeight)
        }
        return imageView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = AppConstants.Images.Login.line
        imageView.snp.makeConstraints {
            $0.width.equalTo(CGFloat.lineWidth)
            $0.height.equalTo(CGFloat.lineHeight)
        }
        return imageView
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Private
    
    private func setup() {
        snp.makeConstraints {
            $0.height.equalTo(CGFloat.height)
            $0.width.equalTo(CGFloat.width)
        }
        addSubview(leftImageView)
        addSubview(label)
        addSubview(rightImageView)
        
        leftImageView.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        rightImageView.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalTo(leftImageView.snp.trailing).offset(-16)
            $0.trailing.equalTo(rightImageView.snp.leading).offset(16)
        }
    }
}

// MARK: - Private Extensions

private extension CGFloat {
    static let height: CGFloat = 20
    static let width: CGFloat = 120
    
    static let lineHeight: CGFloat = 1
    static let lineWidth: CGFloat = 34
}
