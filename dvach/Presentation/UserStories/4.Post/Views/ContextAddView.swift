//
//  ContextAddView.swift
//  dvach
//
//  Created by Kirill Solovyov on 23/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Appodeal

final class ContextAddView: UIView, SeparatorAvailable {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var callToAction: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.textColor = .n1Gray
        callToAction.textColor = .n7Blue
        addTopSeparator(with: .defaultStyle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.makeRoundedByCornerRadius(.radius10)
    }
}

// MARK: - APDNativeAdView

extension ContextAddView: APDNativeAdView {
    
    func titleLabel() -> UILabel {
        return title
    }
    
    func callToActionLabel() -> UILabel {
        return callToAction
    }
    
    func iconView() -> UIImageView {
        return image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ContextAddView", bundle: nil)
    }
}
