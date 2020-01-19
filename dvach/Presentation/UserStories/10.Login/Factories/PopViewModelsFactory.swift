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
                return Model(title: .passwordPop, color: .popUpColor, font: .popUpFont, cornerRadius: 4, maxWidth: 200)
            }
        }
        switch contentType {
        case .name:
            return Model(title: .namePop, color: .popUpColor, font: .popUpFont, cornerRadius: 4, maxWidth: 200)
        case .emailAddress:
            return Model(title: .emailPop, color: .popUpColor, font: .popUpFont, cornerRadius: 4, maxWidth: 200)
        case .password:
            return Model(title: .passwordPop, color: .popUpColor, font: .popUpFont, cornerRadius: 4, maxWidth: 200)
        default: return nil
        }
    }
}

// MARK: - Private Extensions

private extension UIColor {
    static let popUpColor = Theme.current.mainColor
}

private extension UIFont {
    static let popUpFont = AppConstants.Font.regular(size: 13)
}

private extension String {
    static let namePop = AppConstants.Strings.Login.PopUps.namePop
    static let emailPop = AppConstants.Strings.Login.PopUps.emailPop
    static let passwordPop = AppConstants.Strings.Login.PopUps.passwordPop
}
