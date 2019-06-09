//
//  IconView.swift
//  dvach
//
//  Created by Kirill Solovyov on 04/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class IconView: UIView, NibAwakable, ConfigurableView {
    
    struct Model {
        let icon: UIImage
        let text: String?
    }
    
    // Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.backgroundColor = .n7Blue
        icon.tintColor = .white
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        super.awakeAfter(using: aDecoder)
        return awakeAfterCoder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.makeRounded()
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model

    func configure(with model: IconView.Model) {
        icon.image = model.icon.withRenderingMode(.alwaysTemplate)
        if let text = model.text { backgroundView.backgroundColor = UIColor.from(text: text) }
    }
}
