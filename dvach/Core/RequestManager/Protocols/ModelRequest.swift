//
//  ModelRequest.swift
//  NBAStats
//
//  Created by Kirill Solovyov on 06/04/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONParseable {
    static func from(json: JSON) -> Self?
}

protocol ModelRequest {
    associatedtype Model: JSONParseable
}

protocol IRequest: BaseRequest, ModelRequest {}
