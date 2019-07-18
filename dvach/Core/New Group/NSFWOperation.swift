//
//  NSFWOperation.swift
//  dvach
//
//  Created by Ruslan Timchenko on 18/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

final class NSFWOperation: Operation {
    
    public var nsfwCompletionBlock: (((String, Double)?) -> Void)?
    
    private let image: UIImage
    private let url: URL
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
        
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
        
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    
    override var isFinished: Bool {
        return _finished
    }
    
    
    override var isExecuting: Bool {
        return _executing
    }
    
    override func start() {
        _executing = true
        execute()
    }
    
    init(image: UIImage, url: URL) {
        self.image = image
        self.url = url
        super.init()
    }
    
    func execute() {
        guard let nsfwCompletionBlock = nsfwCompletionBlock else {
            finish()
            return
        }
        if isCancelled {
            finish()
            return
        }
        print("NSFW DETECTION OF \(url.absoluteString) STARTED")
        let imageResized = image.square(scaledToSize: 224)
        guard let pixelBuffer = imageResized.toCVPixelBuffer() else {
            nsfwCompletionBlock(nil)
            finish()
            return
        }
        do {
            let nudity = Nudity()
            let output = try nudity.prediction(data: pixelBuffer)
            let classLabel = output.classLabel
            guard let prediction = output.prob[classLabel] else {
                nsfwCompletionBlock(nil)
                finish()
                return
            }

            let nsfwString: String

            if (classLabel == "NSFW" && prediction >= .nsfwPredictionBorder)
                || (classLabel == "SFW" && prediction <= .sfwPredictionBorder) {
                nsfwString = "NSFW"
            } else {
                nsfwString = "SFW"
            }

            print("NSFW DETECTION OF \(url.absoluteString) ENDED")
            nsfwCompletionBlock((nsfwString, prediction))
            finish()
        } catch let err {
            print(err)
            nsfwCompletionBlock(nil)
            finish()
        }
    }
    
    func finish() {
        //Async task complete and hence the operation is complete
        _executing = false
        _finished = true
    }
}
