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
        loadImage(url: url, defaultImage: nil, placeholder: nil, transition: true)
    }
    
    func loadImage(url: String, defaultImage: UIImage?, placeholder: UIImage?, transition: Bool) {
        image = defaultImage
        guard let url = URL(string: "\(GlobalUtils.base2chPath)\(url)") else { return }
        let options =
            ImageLoadingOptions(placeholder: placeholder,
                                transition: transition ? .fadeIn(duration: 0.5) : nil,
                                contentModes: .init(success: .scaleAspectFill,
                                                    failure: .scaleAspectFit,
                                                    placeholder: .scaleAspectFill))
        
        Nuke.loadImage(with: url, options: options, into: self, progress: nil) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure:
                self?.image = defaultImage
            }
        }
    }
}
