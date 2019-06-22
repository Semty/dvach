//
//  SettingsSwitcherView.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol SettingsSwitcherViewDelegate: AnyObject {
    func settingsSwitcherView(_ view: SettingsSwitcherView, didChangeSwitchValue value: Bool)
}

final class SettingsSwitcherView: UIView, ConfigurableView {
    
    struct Model {
        let title: String
        let subtitle: String
        let isSwitcherOn: Bool
    }
    
    // Dependencies
    weak var delegate: SettingsSwitcherViewDelegate?
    
    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .n1Gray
        subtitleLabel.textColor = .n2Gray
        switcher.tintColor = .n5LightGray
    }
    
    // MARK: - Actions
    
    @IBAction func switchAction(_ sender: Any) {
        delegate?.settingsSwitcherView(self, didChangeSwitchValue: switcher.isOn)
    }
    
    // MARK: - ConfigurableView
    
    typealias ConfigurationModel = Model
    
    func configure(with model: SettingsSwitcherView.Model) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        switcher.isOn = model.isSwitcherOn
    }
}
