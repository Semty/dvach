//
//  EULAOfferViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 03/08/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftEntryKit

private extension String {
    static let eulaOfferAgreement = "EULA Offer Agreement"
}

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
        view.backgroundColor = .clear
        eulaView.makeRoundedByCornerRadius(.radiusOfBanner)
        
        eulaButton.setTitleColor(UIColor.n7Blue.withAlphaComponent(0.6), for: .normal)
        agreeButton.configure(with: agreeButtonModel)
        agreeButton.enablePressStateAnimation { [weak self] in
            self?.appSettingsStorage.isEulaCompleted = true
            SwiftEntryKit.dismiss(.specific(entryName: .eulaOfferAgreement),
                                  with: nil)
        }
    }
    
    // MARK: - Public Interface
    
    public func getAnimationAttributes() -> EKAttributes {
        var attributes = EKAttributes()
        if UIDevice.current.userInterfaceIdiom == .pad {
            attributes.position = .center
        } else {
            attributes.position = .bottom
        }
        attributes.positionConstraints = .fullWidth
        attributes.positionConstraints.size = .init(width: .offset(value: 6),
                                                    height: .constant(value: 280))
        attributes.positionConstraints.verticalOffset = 6
        attributes.positionConstraints.maxSize = .init(width: .constant(value: 414),
                                                       height: .constant(value: 556))
        attributes.homeIndicatorBehaviour = .autoHidden
        attributes.positionConstraints.safeArea = .overridden
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .easeOut)
        attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .easeOut)
        attributes.screenBackground = .visualEffect(style: .dark)
        attributes.entranceAnimation =
            .init(translate: .init(duration: 0.7,
                                   spring: .init(damping: 0.7,
                                                 initialVelocity: 0)),
                  scale: .init(from: 0.7, to: 1, duration: 0.4,
                               spring: .init(damping: 1, initialVelocity: 0)))
        attributes.displayDuration = .infinity
        attributes.hapticFeedbackType = .warning
        attributes.name = .eulaOfferAgreement
        return attributes
    }

    
    // MARK: - Actions
    
    @IBAction func eulaAction(_ sender: Any) {
        let viewController = EULAViewController()
        present(viewController, animated: true)
    }
}
