//
//  Extension+Int.swift
//  NBAStats
//
//  Created by Kirill Solovyov on 05/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension Int {
    
    var stringValue: String {
        return "\(self)"
    }
    
    var boolValue: Bool {
        return self != 0
    }
    
    func convertTimestampToStringDate() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return GlobalUtils.dateFormatter.string(from: date)
    }
}
