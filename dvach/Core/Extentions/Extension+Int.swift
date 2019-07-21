//
//  Extension+Int.swift
//  NBAStats
//
//  Created by Kirill Solovyov on 05/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension Int {
    
    static let adPeriod = 3
    static let maxAdCount = 1
    
    var stringValue: String {
        return "\(self)"
    }
    
    var boolValue: Bool {
        return self != 0
    }
    
    var isZero: Bool {
        return self == 0
    }
    
    func convertTimestampToStringDate() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return GlobalUtils.dateFormatter.string(from: date)
    }
    
    func rightWordForNew() -> String {
        let lastNumber = self % 100
        
        switch lastNumber {
        case 1,21,31,41,51,61,71,81,91:
            return "новый"
        default:
            return "новых"
        }
    }
    
    func rightWordForPostsCount() -> String {
        let lastNumber = self % 100
        
        switch lastNumber {
        case 1,21,31,41,51,61,71,81,91:
            return "пост"
        case 2,3,4,22,23,24,32,33,34,42,43,44,52,53,54,62,63,64,72,73,74,82,83,84,92,93,94:
            return "поста"
        default:
            return "постов"
        }
    }
}
