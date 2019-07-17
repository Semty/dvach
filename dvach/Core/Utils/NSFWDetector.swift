//
//  NSFWDetector.swift
//  dvach
//
//  Created by Ruslan Timchenko on 17/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation


class NSFWDetector {
    static let shared = NSFWDetector()
    
    private lazy var nsfwDetectorOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        //operationQueue.maxConcurrentOperationCount = 4
        operationQueue.underlyingQueue = nsfwDetectorBackgroundQueue
        return operationQueue
    }()
    
    private let nsfwDetectorBackgroundQueue =
        DispatchQueue(label: "com.ruslantimchenko.nsfwDetectorBackgroundQueue",
                      qos: .utility)
    
    func predictNSFW(_ image: UIImage, url: URL, completion: @escaping ((String, Double)?) -> Void) {
        let operation = Operation()
        operation.name = url.absoluteString
        operation.completionBlock = {
            let imageResized = image.square(scaledToSize: 224)
            guard let pixelBuffer = imageResized.toCVPixelBuffer() else {
                completion(nil)
                return
            }
            do {
                let nudity = Nudity()
                let output = try nudity.prediction(data: pixelBuffer)
                completion((output.classLabel, output.prob[output.classLabel] ?? 50))
            } catch let err {
                print(err)
                completion(nil)
            }
        }
        nsfwDetectorOperationQueue.addOperation(operation)
    }
}
