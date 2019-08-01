//
//  AboutPresenter.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol IAboutPresenter {
    func viewDidLoad()
    func didTapContactUs()
    func didTapRateUs()
}

final class AboutPresenter {
    
    // Dependencies
    weak var view: (AboutView & UIViewController)?
    
    // MARK: - Private
    
    private var viewModel: AboutViewController.ViewModel {
        return AboutViewController.ViewModel(infoViewModel: infoViewModel,
                                             rulesViewModel: rulesBlockModel,
                                             newsViewModel: newsBlockModel)
    }
    
    private var infoViewModel: AppInfoView.Model {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") else {
            return AppInfoView.Model(version: "Версия 1.0")
        }
        return AppInfoView.Model(version: "Версия \(version)")
    }
    
    private var rulesBlockModel: (BlockWithTitle.Model, String) {
        let rulesBlockModel = BlockWithTitle.Model(title: "Правила", buttonTitle: nil)
        let text = Config.rules
        
        return (rulesBlockModel, text)
    }
    
    private var newsBlockModel: (BlockWithTitle.Model, String) {
        let rulesBlockModel = BlockWithTitle.Model(title: "Новости проекта", buttonTitle: nil)
        let text = Config.news
        
        return (rulesBlockModel, text)
    }
}

// MARK: - IAboutPresenter

extension AboutPresenter: IAboutPresenter {
    
    func viewDidLoad() {
        view?.update(model: viewModel)
    }
    
    func didTapContactUs() {
        guard let url = URL(string: "tg://resolve?domain=dvachios") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            Analytics.logEvent("TelegramLinkTapped", parameters: [:])
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Ошибочка вышла", message: "Установим телеграм?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Да", style: .default, handler: { (UIAlertAction) in
                if let urlAppStore = URL(string: "itms-apps://itunes.apple.com/app/id686449807"),
                    UIApplication.shared.canOpenURL(urlAppStore) {
                    Analytics.logEvent("DownloadTelegramLinkTapped", parameters: [:])
                    UIApplication.shared.open(urlAppStore, options: [:], completionHandler: nil)
                }
            })
            let actionCancel = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(actionCancel)
            view?.present(alert, animated: true)
        }
    }
    
    func didTapRateUs() {
    
    }
}
