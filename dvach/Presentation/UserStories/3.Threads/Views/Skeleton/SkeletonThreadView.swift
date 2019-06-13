//
//  SkeletonThreadView.swift
//  dvach
//
//  Created by Ruslan Timchenko on 13/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class SkeletonThreadView: UIView {
    
    enum State {
        case active
        case nonactive
    }
    
    // Outlets
    @IBOutlet var elements: [UIView]!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        elements.forEach {
            $0.makeRoundedByCornerRadius(.radius10)
            $0.backgroundColor = .n5LightGray
        }
    }
    
    // MARK: - Public
    
    func update(state: State) {
        switch state {
        case .active:
            elements.forEach { $0.addPulseAnimation() }
        case .nonactive:
            elements.forEach { $0.removePulseAnimation() }
        }
    }
}
