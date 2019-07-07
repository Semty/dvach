//
//  VerticalOvalButton.swift
//  dvach
//
//  Created by Kirill Solovyov on 09/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class VerticalOvalButton: UIView, ConfigurableView, Tappable, NibAwakable {
    
    struct Model {
        let color: UIColor
        let icon: UIImage?
        let text: String?
    }
    
    // Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.tintColor = .white
        textLabel.textColor = .white
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
    
    func configure(with model: VerticalOvalButton.Model) {
        backgroundView.backgroundColor = model.color
        icon.image = model.icon?.withRenderingMode(.alwaysTemplate)
        textLabel.text = model.text
        textLabel.isHidden = model.text == nil
    }
}
