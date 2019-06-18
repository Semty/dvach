//
//  CloseButton.swift
//  NBAStats
//
//  Created by Kirill Solovyov on 29/04/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension UIEdgeInsets {
    static let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
}

final public class CloseButton: UIView, Tappable {
    
    private let image: UIImageView = {
        let image = UIImage(named: "close_button")
        let imageView = UIImageView(image: image)
        imageView.snp.makeConstraints { $0.height.width.equalTo(25) }
        
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(image)
        image.snp.makeConstraints { $0.edges.equalToSuperview().inset(UIEdgeInsets.insets) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
