//
//  Extention+Dictionary.swift
//  Receipt
//
//  Created by Kirill Solovyov on 24.02.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

extension Dictionary where Key: StringProtocol, Value: StringProtocol {
    
    var parametersString: String {
        guard !self.isEmpty else { return "" }
        
        var resultString = ""
        self.forEach {
            let valueString = String(describing: $0.value).replacingOccurrences(of: ",", with: "%2C")
            let string = String(describing: $0.key) + "=" + valueString + "&"
            resultString.append(string)
        }
        
        return "?" + resultString.dropLast()
    }
}
