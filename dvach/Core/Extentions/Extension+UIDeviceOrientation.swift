//
//  Extension+UIDeviceOrientation.swift
//  dvach
//
//  Created by Ruslan Timchenko on 11/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UIDeviceOrientation {
    func interfaceOrientation() -> UIInterfaceOrientation {
        switch self {
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        default: return .portrait
        }
    }
    
    func orientationMask() -> UIInterfaceOrientationMask {
        switch self {
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        default: return .portrait
        }
    }
}
