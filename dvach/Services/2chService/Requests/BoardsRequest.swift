//
//  BoardsRequest.swift
//  dvach
//
//  Created by Kirill Solovyov on 30/05/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class BoardsRequest: IRequest {    
    
    typealias Model = Categories
    
    var section: String {
        return "/makaba/mobile"
    }
    
    var format: String {
        return ".fcgi"
    }
    
    var parameters: [String : String] {
        return ["task": "get_boards"]
    }
}
