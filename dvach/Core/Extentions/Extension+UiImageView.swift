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
        loadImage(url: url, defaultImage: nil)
    }
    
    func loadImage(url: String, defaultImage: UIImage?) {
        image = defaultImage
        guard let url = URL(string: "\(GlobalUtils.base2chPath)\(url)") else {
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
