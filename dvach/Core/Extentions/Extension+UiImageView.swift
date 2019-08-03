//
//  Extension+UiImageView.swift
//  dvach
//
//  Created by Kirill Solovyov on 07/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Nuke

private extension Double {
    static let nsfwPredictionBorder = Config.nsfwFilter.nsfwBorder
    static let sfwPredictionBorder = Config.nsfwFilter.sfwBorder
}

extension UIImageView {
    
    func loadImage(url: String, isSafeMode: Bool) {
        loadImage(url: url,
                  defaultImage: nil,
                  placeholder: nil,
                  transition: true,
                  checkNSFW: true,
                  isSafeMode: isSafeMode)
    }
    
    func loadImage(url: String,
                   defaultImage: UIImage?,
                   placeholder: UIImage?,
                   transition: Bool,
                   checkNSFW: Bool,
                   isSafeMode: Bool) {
        image = defaultImage
        guard let url = URL(string: "\(GlobalUtils.base2chPath)\(url)") else { return }
        
        let request: ImageRequest
        
        if checkNSFW {
            request = ImageRequest(url: url,
                                   processors: [ImageProcessor.NSFWImageProcessor(url: url,
                                                                                  nsfwPredictionBorder: .nsfwPredictionBorder,
                                                                                  sfwPredictionBorder: .sfwPredictionBorder,
                                                                                  isSafeMode: isSafeMode)])
        } else {
            request = ImageRequest(url: url)
        }
        
        let options =
            ImageLoadingOptions(placeholder: placeholder,
                                transition: transition ? .fadeIn(duration: 0.5) : nil,
                                contentModes: .init(success: .scaleAspectFill,
                                                    failure: .scaleAspectFit,
                                                    placeholder: .scaleAspectFill))
        
        Nuke.loadImage(with: request, options: options, into: self, progress: nil) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure:
                self?.image = defaultImage
            }
        }
    }
}
