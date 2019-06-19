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
    
    // MARK: - ISettingsPresenter
    
    var blocks: [UIView] {
        let generalModel = ContentSettingsView.Model(title: "Общие настройки", subtitle: "Всякое")
        let generalBlock = createBlock(model: generalModel)
        generalBlock.enablePressStateAnimation {
            
        }
        
        let subscribesModel = ContentSettingsView.Model(title: "Подписки",
                                                        subtitle: "Отключить рекламу, открыть доступ ко всем доскам")
        let subscribesBlock = createBlock(model: subscribesModel)
        subscribesBlock.enablePressStateAnimation {
            
        }
        
        let aboutModel = ContentSettingsView.Model(title: "О приложении", subtitle: "Новости проекта, написать разработчикам")
        let aboutBlock = createBlock(model: aboutModel)
        aboutBlock.enablePressStateAnimation {
            
        }
        
        return [generalBlock, subscribesBlock, aboutBlock]
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
