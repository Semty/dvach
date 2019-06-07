//
//  Extension+UiImageView.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Nuke

extension UIImageView {
    
    func loadImage(url: String) {
        guard let url = URL(string: "https://2ch.hk\(url)") else {
            image = nil
            return
        }
        
        Nuke.loadImage(
            with: url,
            options: ImageLoadingOptions(
                transition: .fadeIn(duration: 0.5),
                contentModes: .init(
                    success: .scaleAspectFill,
                    failure: .center,
                    placeholder: .center
                )
            ),
            into: self
        )
    }
}
