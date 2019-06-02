//
//  Extension+Data.swift
//  dvach
//
//  Created by Ruslan Timchenko on 02/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    
    var attributedString: NSMutableAttributedString? {
        do {
            return try NSMutableAttributedString(data: self,
                                                 options:
                [.documentType: NSAttributedString.DocumentType.html,
                 .characterEncoding: String.Encoding.utf8.rawValue],
                                                 documentAttributes: nil)
        } catch {
            print(error)
        }
        return nil
    }
}
