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
    
    // UI
    private lazy var animationView = AnimationView(name: "monkey")
    
    // Delegate
    public weak var delegate: LaunchAnimationViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .n7Blue
        view.addSubview(animationView)
        animationView.frame = CGRect(x: view.bounds.width,
                                     y: view.bounds.origin.y,
                                     width: view.bounds.width,
                                     height: view.bounds.height)
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.animationView.frame = self.view.bounds
        }
    }
    
    // MARK: - Load Data
    
    private func loadData() {
        animationView.loopMode = .playOnce
        
        let group = DispatchGroup()
        group.enter()
        animationView.play { _ in
            group.leave()
        }
        
        group.enter()
        firebaseService.updateConfig {
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.delegate?.endSplashScreen()
        }
    }
}
