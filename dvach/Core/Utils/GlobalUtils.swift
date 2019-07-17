//
//  GlobalUtils.swift
//  Receipt
//
//  Created by Kirill Solovyov on 22.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

public enum GlobalUtils {
    public static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    public static let backgroundNSFWDetectionQueue = DispatchQueue(label: "com.ruslantimchenko.imagensfwbackgroundactivity",
                                                                   qos: .utility,
                                                                   attributes: .concurrent)
}
