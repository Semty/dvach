//
//  Extention+String.swift
//  Receipt
//
//  Created by Kirill Solovyov on 25.02.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

extension String {
    
    var data: Data {
        return Data(utf8)
    }
    
    var removeSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var capitalizingFirstLetter: String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
