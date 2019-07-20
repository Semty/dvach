//
//  GeneralSettingsViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol GeneralSettingsView: AnyObject {
    func update(model: GeneralSettingsViewController.Model)
}

final class GeneralSettingsViewController: UIViewController {
    
    struct Model {
        let nsfwViewModel: SettingsSwitcherView.Model
    }
    
    // Dependencies
    private let presenter: IGeneralSettingsPresenter
    private let componentsFactory = Locator.shared.componentsFactory()
    private lazy var adManager = Locator.shared.createAdManager(numberOfNativeAds: 0,
                                                                viewController: self)
    
    // UI
    private lazy var stackView = componentsFactory.createStackViewContainer()
    private lazy var nsfwView: SettingsSwitcherView = {
        let view = SettingsSwitcherView.fromNib()
        view.delegate = self
        
        return view
    }()
    
    override var prefersStatusBarHidden: Bool {
        hideStatusBar(false, animation: true)
        return false
    }
    
    // MARK: - Initialization
    
    init() {
        let presenter = GeneralSettingsPresenter()
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        title = "Основные"
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        stackView.shouldFillRemainingSpace = false
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        stackView.addView(nsfwView)
    }
}

// MARK: - GeneralSettingsView

extension GeneralSettingsViewController: GeneralSettingsView {
    
    func update(model: GeneralSettingsViewController.Model) {
        nsfwView.configure(with: model.nsfwViewModel)
    }
}

// MARK: - SettingsSwitcherViewDelegate

extension GeneralSettingsViewController: SettingsSwitcherViewDelegate {
    
    func settingsSwitcherView(_ view: SettingsSwitcherView, didChangeSwitchValue value: Bool) {
        adManager.showInterstitialAd()
        presenter.didChangeNSFWSwitchValue(value)
    }
}
