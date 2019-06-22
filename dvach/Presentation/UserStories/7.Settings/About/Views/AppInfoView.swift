//
//  AppInfoView.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class AppInfoView: UIView, ConfigurableView {
    
    struct Model {
        let version: String
    }
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .n1Gray
        titleLabel.text = "Двач"
        versionLabel.textColor = .n2Gray
        imageView.image = #imageLiteral(resourceName: "light.png").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .n7Blue
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: AppInfoView.Model) {
        versionLabel.text = model.version
    }
}
