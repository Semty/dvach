//
//  AboutViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 22/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol AboutView: AnyObject {
    func update(model: AboutViewController.ViewModel)
}

final class AboutViewController: UIViewController {
    
    struct ViewModel {
        let infoViewModel: AppInfoView.Model
        let rulesViewModel: (BlockWithTitle.Model, String)
        let newsViewModel: (BlockWithTitle.Model, String)
    }
    
    // Dependencies
    private let presenter: IAboutPresenter
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // UI
    private lazy var stackView = componentsFactory.createStackViewContainer()
    private lazy var appInfoView = AppInfoView.fromNib()
    private lazy var rulesBlock = componentsFactory.createBlockWithTitle()
    private lazy var rulesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .n2Gray
        label.font = UIFont.systemFont(ofSize: .size12, weight: .semibold)
        label.numberOfLines = 0

        return label
    }()
    private lazy var newsBlock = componentsFactory.createBlockWithTitle()
    private lazy var newsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .n2Gray
        label.font = UIFont.systemFont(ofSize: .size12, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    private lazy var contactUsView: ConnectUsView = {
        let view = ConnectUsView.fromNib()
        view.enablePressStateAnimation { [weak self] in
            self?.presenter.didTapContactUs()
        }
        return view
    }()
    private lazy var rateUs: BottomButton = {
        let button = BottomButton()
        let model = BottomButton.Model(text: "Оценить приложение",
                                       backgroundColor: .n7Blue,
                                       textColor: .white)
        button.configure(with: model)
        button.snp.makeConstraints { $0.height.equalTo(45) }
        button.enablePressStateAnimation { [weak self] in
            self?.presenter.didTapRateUs()
        }
        return button
    }()
    
    // MARK: - Initialization
    
    init() {
        let presenter = AboutPresenter()
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
        title = "О приложении"
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true
        
        view.addSubview(stackView)
        stackView.contentInset.bottom = .inset20
        stackView.shouldFillRemainingSpace = false
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        stackView.addView(appInfoView)
        stackView.addView(rulesBlock)
        stackView.addView(newsBlock)
        stackView.addView(contactUsView)
        
        // TODO: - Добавить со след версии
//        stackView.addView(rateUs.wrappedInContantContainer)
        
        rulesBlock.addView(rulesLabel.wrappedInContantContainer)
        newsBlock.addView(newsLabel.wrappedInContantContainer)
    }
}

// MARK: - AboutView

extension AboutViewController: AboutView {
    
    func update(model: AboutViewController.ViewModel) {
        appInfoView.configure(with: model.infoViewModel)
        rulesLabel.text = model.rulesViewModel.1
        rulesBlock.configure(with: model.rulesViewModel.0)
        newsLabel.text = model.newsViewModel.1
        newsBlock.configure(with: model.newsViewModel.0)
    }
}
