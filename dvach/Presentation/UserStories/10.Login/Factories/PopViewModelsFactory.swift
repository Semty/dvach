//
//  PopViewModelsFactory.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 24.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation

protocol IPopViewModelsFactory {
    func getModel(with contentType: UITextContentType) -> PopViewModelsFactory.Model?
}

final class PopViewModelsFactory: IPopViewModelsFactory {
    
    struct Model {
        let title: String
        let color: UIColor
        let font: UIFont
        let cornerRadius: CGFloat
        let maxWidth: CGFloat
    }
    
    // MARK: - IPopViewModelsFactory
    
    func getModel(with contentType: UITextContentType) -> Model? {
        if #available(iOS 12.0, *) {
            if contentType == .newPassword {
                return Model(title: "passwordPop", color: .black, font: UIFont(), cornerRadius: 4, maxWidth: 200)
            }
        }
        switch contentType {
        case .name:
            return Model(title: "namePop", color: .black, font: UIFont(), cornerRadius: 4, maxWidth: 200)
        case .emailAddress:
            return Model(title: "emailPop", color: .black, font: UIFont(), cornerRadius: 4, maxWidth: 200)
        case .password:
            return Model(title: "passwordPop", color: .black, font: UIFont(), cornerRadius: 4, maxWidth: 200)
        default: return nil
        }
    }
}
