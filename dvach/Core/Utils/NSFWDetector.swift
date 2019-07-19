//
//  NSFWDetector.swift
//  dvach
//
//  Created by Ruslan Timchenko on 17/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension Double {
    static let nsfwPredictionBorder = 0.49
    static let sfwPredictionBorder = 0.98
}

class NSFWDetector {
    static let shared = NSFWDetector()
    
    private lazy var nsfwDetectorOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.underlyingQueue = nsfwDetectorBackgroundQueue
        return operationQueue
    }()
    
    private let nsfwDetectorBackgroundQueue =
        DispatchQueue(label: "com.ruslantimchenko.nsfwDetectorBackgroundQueue",
                      qos: .utility)
    
    public func predictNSFW(_ image: UIImage, url: URL, completion: @escaping ((String, Double)?) -> Void) {
        print("PREDICT")
        isOperationExecuting(url.absoluteString) { (operation) in
            if let _ = operation {
                completion(nil)
            }
        }
        
        let nsfwOperation = NSFWOperation(image: image, url: url)
        nsfwOperation.name = url.absoluteString
        nsfwOperation.nsfwCompletionBlock = { nsfwResponse in
            completion(nsfwResponse)
        }
        nsfwDetectorOperationQueue.addOperation(nsfwOperation)
    }
    
    public func cancelNSFWDetectionIfNeeded(_ name: String) {
        isOperationExecuting(name) { (operation) in
            if let operation = operation {
                operation.cancel()
            }
        }
    }
    
    // MARK: - Helpful Functions
    
    private func isOperationExecuting(_ name: String, completion: (Operation?) -> Void) {
        print(nsfwDetectorOperationQueue.operations.count)
        nsfwDetectorOperationQueue.operations.forEach { operation in
            if operation.name == name {
                print("\n\nOPERATION \(name) CANCELLED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n")
                completion(operation)
            }
        }
        completion(nil)
    }
}
