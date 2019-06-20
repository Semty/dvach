//
//  HorizontalMoreButton.swift
//  dvach
//
//  Created by Ruslan Timchenko on 20/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension CGFloat {
    static let buttonSize: CGFloat = 25
}

final public class HorizontalMoreButton: UIView, Tappable {
    
    private let imageColor: UIColor?
    
    private lazy var image: UIImageView = {
        let image = UIImage.moreIcon(size: CGSize(width: 16, height: 16),
                                     color: imageColor)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.snp.makeConstraints { $0.height.width.equalTo(CGFloat.buttonSize) }
        
        return imageView
    }()
    
    init(_ color: UIColor? = nil) {
        imageColor = color
        super.init(frame: .zero)
        addSubview(image)
        image.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
