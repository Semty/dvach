//
//  Shadow.swift
//  dvach
//
//  Created by Kirill Solovyov on 04/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit

public final class ShadowCollectionViewCell: UICollectionViewCell, PressStateAnimatable, ConfigurableView {
    
    /// Конфигурационная модель
    public struct Model {
        public let underlyingShadow: Shadow?
        public let shadow: Shadow?
        
        public  init(underlyingShadow: Shadow?,
                     shadow: Shadow?) {
            self.underlyingShadow = underlyingShadow
            self.shadow = shadow
        }
    }
    
    // UI
    @IBOutlet weak var coloredShadowView: UIView!
    
    // MARK: - Lifecycle
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        coloredShadowView.isHidden = true
    }
    
    // MARK: - Public
    
    public func animatePressStateChange(pressed: Bool) {
        animatePressStateChange(pressed: pressed, minScale: 0.9, duration: 0.1)
    }
    
    // MARK: - Configurable
    
    public typealias ConfigurationModel = Model
    
    public func configure(with model: Model) {
        if let underlyingShadow = model.underlyingShadow, let shadowColor = underlyingShadow.color {
            layer.shadowColor = shadowColor.cgColor
            layer.shadowPath = CGPath(rect: self.bounds, transform: nil)
            layer.shadowOffset = CGSize(width: 0, height: underlyingShadow.offsetY)
            layer.shadowOpacity = Float(underlyingShadow.opacity)
            layer.shadowRadius = underlyingShadow.radius
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
        if let shadow = model.shadow, let shadowColor = shadow.color {
            coloredShadowView.isHidden = false
            coloredShadowView.layer.shadowOffset = CGSize(width: 0, height: shadow.offsetY)
            coloredShadowView.layer.shadowOpacity = Float(shadow.opacity)
            coloredShadowView.layer.shadowRadius = shadow.radius
            coloredShadowView.layer.shadowPath = CGPath(rect: self.bounds, transform: nil)
            coloredShadowView.layer.shouldRasterize = true
            coloredShadowView.layer.rasterizationScale = UIScreen.main.scale
            coloredShadowView.layer.shadowColor = shadowColor.cgColor
        }
    }
}
