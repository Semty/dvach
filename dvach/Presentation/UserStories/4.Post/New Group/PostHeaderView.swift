//
//  PostHeaderView.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class PostHeaderView: UIView, ConfigurableView, ReusableView {
    
    struct Model {
        let title: String
        let subtitle: Int
        let number: Int
    }
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var roundNumberView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .n1Gray
        subtitleLabel.textColor = .n7Blue
        roundNumberView.backgroundColor = .n7Blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundNumberView.makeRounded()
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: PostHeaderView.Model) {
        titleLabel.text = model.title
        subtitleLabel.text = "№ \(model.subtitle)"
        numberLabel.text = "#\(model.number)"
    }
}
