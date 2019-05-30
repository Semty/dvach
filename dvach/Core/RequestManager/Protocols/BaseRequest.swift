//
//  BaseRequest.swift
//  Receipt
//
//  Created by Kirill Solovyov on 24.02.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol BaseRequest {
    var payloadKey: String? { get }
    var accessLevel: String { get }
    var version: String { get }
    var language: String { get }
    var format: String { get }
    var section: String { get }
    var action: String { get }
    var parameters: [String: String] { get }
}

extension BaseRequest {
    
    var baseURL: String {
        return "https://2ch.hk"
    }
    
    var accessLevel: String {
        return ""
    }
    
    var version: String {
        return ""
    }
    
    var language: String {
        return ""
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    var format: String {
        return ".json"
    }
    
    var payloadKey: String? {
        return nil
    }
    
    var section: String {
        return ""
    }
    
    var action: String {
        return ""
    }
    
    var parameters: [String: String] {
        return [:]
    }
}
