//
//  BadWordsString.swift
//  dvach
//
//  Created by Kirill Solovyov on 06/08/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

public final class BadWords {

    // Dependencies
    private let configService = Locator.shared.configService()
    
    // Singleton
    public static let shared = BadWords()
    private init() {}
    
    // Public
    public lazy var string: String = {
        let string = configService.readBadWordsConfig()["badWords"].stringValue
        return string.replacingOccurrences(of: ",", with: "|")
    }()
}
