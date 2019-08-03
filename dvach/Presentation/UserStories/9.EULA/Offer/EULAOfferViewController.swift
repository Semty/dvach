//
//  EULAOfferViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 03/08/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class EULAOfferViewController: UIViewController {
    
    // Dependencies
    private let appSettingsStorage = Locator.shared.appSettingsStorage()

    // Outlets
    @IBOutlet weak var eulaView: UIView!
    @IBOutlet weak var eulaButton: UIButton!
    @IBOutlet weak var agreeButton: BottomButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    
    private var agreeButtonModel = BottomButton.Model(text: "Принять", backgroundColor: .n7Blue, textColor: .white)
    
    private func setupUI() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        eulaView.makeRoundedByCornerRadius(.radius12)
        eulaView.layer.borderWidth = 0.3
        eulaView.layer.borderColor = UIColor.n2Gray.cgColor
        
        eulaButton.setTitleColor(.n7Blue, for: .normal)
        agreeButton.configure(with: agreeButtonModel)
        agreeButton.enablePressStateAnimation { [weak self] in
            self?.appSettingsStorage.isEulaCompleted = true
            self?.dismiss(animated: true)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func eulaAction(_ sender: Any) {
        let viewController = EULAViewController()
        present(viewController, animated: true)
    }
}
