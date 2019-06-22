//
//  BannerViewController.swift
//  dvach
//
//  Created by Ruslan Timchenko on 18/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit
import SwiftEntryKit

private extension String {
    static let bannerViewWarning = "BannerView Warning"
    
    static var bannerTitle: String {
        return "NSFW"
    }
    static var bannerDescription: String {
        return """
        - Содержимое данного приложения предназначено ТОЛЬКО для лиц, достигших совершеннолетия. Если вы несовершеннолетний, нажмите "Выйти" и удалите приложение.

        - На данной доске может быть контент эротического содержания, а также контент, явно оскорбляющий ваши чувства. Если вы чувствуете, что ваши чувства могут быть задеты, нажмите "Выйти" и удалите приложение.
        
        - Нажав на "Продолжить", вы соглашаетесь с тем, что разработчики приложения не несут ответственности за любые неудобства, которые может понести за собой использование вами приложения, а также, что вы понимаете, что опубликованное на сайте содержимое не является собственностью или созданием Двача, однако принадлежит и создается пользователями Двача.
        """
    }
}

protocol BannerViewControllerDelegate: AnyObject {
    func didTapAgree()
    func didTapDisagree()
}

final class BannerViewController: UIViewController {

    // Dependencies
    weak var delegate: BannerViewControllerDelegate?
    
    // UI
    private lazy var bannerView: BannerView = {
        let bannerView = BannerView.fromNib()
        let model = BannerView.Model(image: UIImage(named: "warning") ?? UIImage(),
                                     imageColor: .n4Red,
                                     backgroundColor: .white,
                                     title: .bannerTitle,
                                     description: .bannerDescription)
        bannerView.delegate = self
        bannerView.configure(with: model)
        return bannerView
    }()
    
    // Presenting View Controller
    public weak var presentingVC: UIViewController?
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        view = bannerView
    }
    
    // MARK: - Public Interface
    public func getAnimationAttributes(presentingVC: UIViewController) -> EKAttributes {
        self.presentingVC = presentingVC
        var attributes = EKAttributes()
        attributes.position = .bottom
        attributes.positionConstraints = .fullWidth
        attributes.positionConstraints.size = .init(width: .offset(value: 6),
                                                    height: .intrinsic)
        attributes.positionConstraints.verticalOffset = 6
        attributes.positionConstraints.maxSize = .init(width: .intrinsic,
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
        attributes.statusBar = .hidden
        attributes.displayDuration = .infinity
        attributes.hapticFeedbackType = .warning
        attributes.name = .bannerViewWarning
        return attributes
    }
}

extension BannerViewController: BannerViewDelegate {
    
    func userAgreedWithBannerWarning() {
        SwiftEntryKit.dismiss(.specific(entryName: .bannerViewWarning),
                              with: nil)
        delegate?.didTapAgree()
    }
    
    func userDisagreedWithBannerWarning() {
        if let presentingVC = self.presentingVC {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                SwiftEntryKit.dismiss(.specific(entryName: .bannerViewWarning),
                                      with: nil)
            }
            presentingVC.navigationController?.popViewController(animated: true)
            CATransaction.commit()
        } else {
            SwiftEntryKit.dismiss(.specific(entryName: .bannerViewWarning),
                                  with: nil)
        }
        delegate?.didTapDisagree()
    }
}
