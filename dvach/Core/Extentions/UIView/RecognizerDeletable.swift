//
//  RecognizerDeletable.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

public protocol RecognizerDeletable {
    
    /// Удаление UIGestureRecognizer по классу
    @discardableResult
    func deleteRecognizer<T>(recognizerClass: T.Type) -> Bool
}

public extension RecognizerDeletable where Self: UIView {
    
    func deleteRecognizer<T>(recognizerClass: T.Type) -> Bool {
        
        guard let allRecognizers = gestureRecognizers else {
            return false
        }
        
        var didDeleteRecognizer = false
        for recognizer in allRecognizers where recognizer is T {
            self.gestureRecognizers?.removeObject(recognizer)
            didDeleteRecognizer = true
        }
        
        return didDeleteRecognizer
    }
}
