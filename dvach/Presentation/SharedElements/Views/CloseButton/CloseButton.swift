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

final public class CloseButton: UIView, Tappable {
    
    public enum Style {
        case dismiss
        case pop
    }
    
    // Variables
    private let style: Style
    private let imageColor: UIColor?
    
    // UI
    private lazy var image: UIImageView = {
        let image: UIImage
        switch style {
        case .dismiss:
            let size = CGSize(width: .buttonSize/2.4, height: .buttonSize/2.4)
            image = .cancelIcon(size: size, color: imageColor ?? .white)
        case .pop:
            let size = CGSize(width: .buttonSize/1.8, height: .buttonSize/1.8)
            image = .backIcon(size: size, color: imageColor ?? .white)
        }
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
    
    init(style: Style, imageColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        self.style = style
        self.imageColor = imageColor
        
        super.init(frame: .zero)
        
        addSubview(backgroundView)

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
