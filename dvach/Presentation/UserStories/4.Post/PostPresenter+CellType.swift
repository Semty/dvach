//
//  PostPresenter+CellType.swift
//  dvach
//
//  Created by Kirill Solovyov on 04/08/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import DeepDiff

extension PostPresenter {
    
    enum CellType: DiffAware {
        case post(PostCommentViewModel)
        case ad(ContextAddView)
        
        var postNumber: String? {
            switch self {
            case .post(let model):
                return model.postNumber
            default:
                return nil
            }
        }
        
        var isAd: Bool {
            switch self {
            case .ad:
                return true
            case .post:
                return false
            }
        }
        
        // DiffAware
        typealias DiffId = String
        
        var diffId: String {
            switch self {
            case .post(let model):
                return model.id
            case .ad(let model):
                return model.id
            }
        }
        
        private var description: String {
            switch self {
            case .post(let model):
                return model.description
            case .ad(let model):
                return model.adDescription
            }
        }
        
        static func compareContent(_ a: PostPresenter.CellType,
                                   _ b: PostPresenter.CellType) -> Bool {
            return a.description == b.description
        }
        
    }
}
