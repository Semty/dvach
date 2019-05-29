//
//  Extension+NSError.swift
//  FatFood
//
//  Created by Kirill Solovyov on 05.11.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

extension NSError {
    
    static func defaultError(description: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: description]
        return NSError(domain: "default", code: 999, userInfo: userInfo)
    }
}
