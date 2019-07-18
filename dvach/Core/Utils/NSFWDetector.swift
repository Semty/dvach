//
//  NSFWDetector.swift
//  dvach
//
//  Created by Ruslan Timchenko on 17/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

extension Double {
    static let nsfwPredictionBorder = 0.52
    static let sfwPredictionBorder = 0.72
}

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
                let classLabel = output.classLabel
                guard let prediction = output.prob[classLabel] else {
                    completion(nil)
                    return
                }
                
                let nsfwString: String
                
                if (classLabel == "NSFW" && prediction >= .nsfwPredictionBorder)
                    || (classLabel == "SFW" && prediction <= .sfwPredictionBorder) {
                    nsfwString = "NSFW"
                } else {
                    nsfwString = "SFW"
                }

                completion((nsfwString, prediction))
            } catch let err {
                print(err)
                completion(nil)
            }
        }
        nsfwDetectorOperationQueue.addOperation(operation)
    }
}
