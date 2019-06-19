//
//  SettingsView.swift
//  dvach
//
//  Created by Kirill Solovyov on 19/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class ContentSettingsView: UIView, ConfigurableView {
    
    struct Model {
        let title: String
        let subtitle: String
    }
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .n1Gray
        subtitleLabel.textColor = .n2Gray
        snp.makeConstraints { $0.height.equalTo(80) }
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: ContentSettingsView.Model) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
}
