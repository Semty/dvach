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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .n7Blue
        view.addSubview(animationView)
        animationView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        loadData()
    }
    
    // MARK: - Private
    
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
            self?.dismiss(animated: true)
        }
    }
}
