//
//  GeneralSettingsPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IGeneralSettingsPresenter {
    func viewDidLoad()
}

final class GeneralSettingsPresenter {
    
    // Dependencies
    weak var view: GeneralSettingsView?
    
    // MARK: - Private
    
    private var nsfwViewModel: SettingsSwitcherView.Model {
        let subtitle = "Баннер, предупреждающий об эротическом/оскорбляющем контенте будет появляться однократно для каждой доски"
        return SettingsSwitcherView.Model(title: "Отключить предупреждения о NSFW",
                                          subtitle: subtitle,
                                          isSwitcherOn: false)
    }
}

// MARK: - IGeneralSettingsPresenter

extension GeneralSettingsPresenter: IGeneralSettingsPresenter {
    
    func viewDidLoad() {
        let model = GeneralSettingsViewController.Model(nsfwViewModel: nsfwViewModel)
        view?.update(model: model)
    }
}
