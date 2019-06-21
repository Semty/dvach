//
//  DTImageView.swift
//  dvach
//
//  Created by Ruslan Timchenko on 18/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit
import FLAnimatedImage

class DTImageView: FLAnimatedImageView {
    override var image: UIImage? {
        didSet {
            imageChangeBlock?(image)
        }
    }
    
    var imageChangeBlock: ((UIImage?) -> Void)?
}
