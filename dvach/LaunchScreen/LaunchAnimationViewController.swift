//
//  LaunchAnimationViewController.swift
//  dvach
//
//  Created by Kirill Solovyov on 19/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Lottie

final class LaunchAnimationViewController: UIViewController {
    
    // Dependencies
    private lazy var firebaseService = Locator.shared.configService()
    private let appSettingsStorage = Locator.shared.appSettingsStorage()

    // UI
    private lazy var animationView = AnimationView(name: "monkey")
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.bounds.size = CGSize(width: 300, height: 300)
        imageView.image = UIImage(named: "whiteDvachIcon")
        return imageView
    }()
    
    // Delegate
    public weak var delegate: LaunchAnimationViewControllerDelegate?
    
    // Overridden Variables
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .n7Blue
        view.addSubview(animationView)
        view.addSubview(iconImageView)
        animationView.frame = CGRect(x: view.bounds.width,
                                     y: view.bounds.origin.y,
                                     width: view.bounds.width,
                                     height: view.bounds.height)
        iconImageView.center = view.center
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.animationView.frame = self.view.bounds
            })
            UIView.addKeyframe(withRelativeStartTime: 5/10, relativeDuration: 5/10, animations: {
                self.iconImageView.transform =
                    CGAffineTransform.init(translationX: -self.view.bounds.width, y: 0)
            })
        }) { [weak self] _ in
            self?.iconImageView.isHidden = true
        }
    }
    
    // MARK: - Load Data
    
    private func loadData() {
        animationView.loopMode = .playOnce
        
        let group = DispatchGroup()
        group.enter()
        animationView.play { _ in group.leave() }
        
//        group.enter()
//        firebaseService.updateConfig { [weak self] in
//            guard let self = self else {
//                group.leave()
//                return
//            }
//            let previousVersion = self.appSettingsStorage.previousBadWordsVersion
//            let currentVersion = Config.badWordsVersion
//            self.appSettingsStorage.previousBadWordsVersion = currentVersion
//
//            if previousVersion != currentVersion {
//                self.firebaseService.updateBadWordsConfig { group.leave() }
//            } else {
//                group.leave()
//            }
//        }
        
        group.notify(queue: .main) { [weak self] in
            self?.delegate?.endSplashScreen()
        }
    }
}
