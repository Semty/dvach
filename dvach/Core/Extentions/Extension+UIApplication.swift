//
//  Extension+UIApplication.swift
//  dvach
//
//  Created by Kirill Solovyov on 23/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Appodeal

extension UIApplication {
    
    func showNonskipableAd() {
        if Appodeal.isReadyForShow(with: .nonSkippableVideo), let vc = keyWindow?.rootViewController {
            Appodeal.showAd(.nonSkippableVideo, rootViewController: vc)
        }
    }
}
