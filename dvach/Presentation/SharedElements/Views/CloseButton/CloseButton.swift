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

private extension CGFloat {
    static let buttonSize: CGFloat = 25
}

private extension UIColor {
    static let buttonDefaultColor: UIColor = .n5LightGray
}

final public class CloseButton: UIView, Tappable {
    
    // Variables
    private var imageColor: UIColor?
    
    // UI
    private lazy var image: UIImageView = {
        let image = UIImage.cancelIcon(size: CGSize(width: .buttonSize/2.4,
                                                    height: .buttonSize/2.4),
                                       color: imageColor ?? .white)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.snp.makeConstraints { $0.height.width.equalTo(CGFloat.buttonSize) }
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.snp.makeConstraints { $0.height.width.equalTo(CGFloat.buttonSize) }
        view.layer.cornerRadius = .buttonSize / 2
        view.effect = UIBlurEffect(style: .dark)
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.snp.makeConstraints { $0.height.width.equalTo(CGFloat.buttonSize) }
        view.layer.cornerRadius = .buttonSize / 2
        return view
    }()
    
    init(_ imageColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        super.init(frame: .zero)
        addSubview(backgroundView)
        
        self.imageColor = imageColor
        
        if let backgroundColor = backgroundColor {
            backgroundView.backgroundColor = backgroundColor
        } else {
            backgroundView.addSubview(blurView)
        }
        
        backgroundView.addSubview(image)
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview().inset(UIEdgeInsets.insets) }
        image.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
