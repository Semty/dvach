//
//  SettingsPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 19/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol ISettingsPresenter {
    var blocks: [UIView] { get }
}

final class SettingsPresenter: ISettingsPresenter {
    
    // Dependencies
    weak var view: (SettingsView & UIViewController)?
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - ISettingsPresenter
    
    var blocks: [UIView] {
        let generalModel = ContentSettingsView.Model(title: "Общие настройки", subtitle: "Безопасный режим")
        let generalBlock = createBlock(model: generalModel)
        generalBlock.enablePressStateAnimation { [weak self] in
            let general = GeneralSettingsViewController()
            self?.view?.navigationController?.pushViewController(general, animated: true)
        }
        
//        let subscribesModel = ContentSettingsView.Model(title: "Подписки",
//                                                        subtitle: "Отключить рекламу, открыть доступ ко всем доскам")
//        let subscribesBlock = createBlock(model: subscribesModel)
//        subscribesBlock.enablePressStateAnimation { [weak self] in
//            let subscribes = SubscribesViewController()
//            self?.view?.navigationController?.pushViewController(subscribes, animated: true)
//        }
        
        let aboutModel = ContentSettingsView.Model(title: "О приложении", subtitle: "Правила и новости проекта, EULA, написать разработчикам, оценить приложение")
        let aboutBlock = createBlock(model: aboutModel)
        aboutBlock.enablePressStateAnimation { [weak self] in
            let about = AboutViewController()
            self?.view?.navigationController?.pushViewController(about, animated: true)
        }
        
        return [generalBlock, aboutBlock]
    }
    
    // MARK: - Private
    
    private func createBlock(model: ContentSettingsView.Model) -> ShadowViewContainer {
        let contentView = ContentSettingsView.fromNib()
        contentView.configure(with: model)
        let container = ShadowViewContainer(insets: UIEdgeInsets(top: 5, left: .inset16, bottom: 5, right: .inset16))
        container.contentView = contentView

        return container
    }
}
