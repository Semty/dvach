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
        
        var postNumber: String? {
            switch self {
            case .post(let model):
                return model.postNumber
            }
        }
        
        // DiffAware
        typealias DiffId = String
        
        var diffId: String {
            switch self {
            case .post(let model):
                return model.id
            }
        }
        
        private var description: String {
            switch self {
            case .post(let model):
                return model.description
            }
        }
        
        static func compareContent(_ a: PostPresenter.CellType,
                                   _ b: PostPresenter.CellType) -> Bool {
            return a.description == b.description
        }
    }
}
