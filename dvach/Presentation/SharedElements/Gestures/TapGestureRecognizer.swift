//
//  TapGestureRecognizer.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

public final class TapGestureRecognizer: UITapGestureRecognizer {
    
    private let handler:(() -> Void)?
    
    @objc public required init(handler:(() -> Void)?) {
        self.handler = handler
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(handleTap))
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        handler?()
    }
}
