//
//  ReportResponse.swift
//  dvach
//
//  Created by Ruslan Timchenko on 25/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ReportResponse {
    let message: String
    let messageTitle: String
}

// MARK: - JSONParsable

extension ReportResponse: JSONParsable {
    
    static func from(json: JSON) -> ReportResponse? {
        guard let message = json["message"].string,
            let messageTitle = json["message_title"].string else { return nil }
        
        return ReportResponse(message: message, messageTitle: messageTitle)
    }
}
