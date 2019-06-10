//
//  SkeletonPostView.swift
//  dvach
//
//  Created by Kirill Solovyov on 10/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class SkeletonPostView: UIView {
    
    enum State {
        case active
        case nonactive
    }
    
    // Outlets
    @IBOutlet var viewsCollection: [UIView]!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewsCollection.forEach {
            $0.makeRoundedByCornerRadius(.radius10)
            $0.backgroundColor = .n5LightGray
        }
    }
    
    // MARK: - Public
    
    func update(state: State) {
        switch state {
        case .active:
            viewsCollection.forEach { $0.addPulseAnimation() }
        case .nonactive:
            viewsCollection.forEach { $0.removePulseAnimation() }
        }
    }
}
