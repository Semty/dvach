//
//  SettingsViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 19/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

private extension CGFloat {
    static let headerHeight: CGFloat = 130
    static let contentInset: CGFloat = 70
}

protocol SettingsView: AnyObject {
    
}

final class SettingsViewController: UIViewController {
    
    // Dependencies
    private let presenter: ISettingsPresenter
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // UI
    private lazy var stackView = componentsFactory.createStackViewContainer()
    private lazy var header: UIView = {
        let view = UIView()
        view.backgroundColor = .n7Blue
        let image = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        let icon = UIImageView(image: image)
        icon.tintColor = .white
        view.addSubview(icon)
        icon.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(CGFloat.inset16)
            $0.width.height.equalTo(50)
        }
        
        return view
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        header.snp.updateConstraints { $0.height.equalTo(CGFloat.headerHeight + view.safeAreaInsets.top)}
    }
    
    // MARK: - Initialization
    
    init() {
        let presenter = SettingsPresenter()
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
        presenter.blocks.forEach(stackView.addView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.addSubview(header)
        header.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(CGFloat.headerHeight)
        }
        
        view.addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.showsVerticalScrollIndicator = false
        stackView.contentInset.top = .contentInset
        stackView.isScrollEnabled = false
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

// MARK: - SettingsView

extension SettingsViewController: SettingsView {
    
}
