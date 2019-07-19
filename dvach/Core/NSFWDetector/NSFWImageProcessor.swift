//
//  NSFWImageProcessor.swift
//  dvach
//
//  Created by Ruslan Timchenko on 19/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Nuke

private extension Double {
    static let nsfwPredictionBorder = 0.49
    static let sfwPredictionBorder = 0.98
}


extension ImageProcessor {
    public struct NSFWImageProcessor: ImageProcessing, Hashable, CustomStringConvertible {
        
        private let url: URL
        
        public init(url: URL) {
            self.url = url
        }
        
        public func process(image: Image, context: ImageProcessingContext?) -> Image? {
            let nsfwResponse = detectNSFW(image)
            
            if nsfwResponse?.0 == "NSFW" {
                return blur(image: image, radius: 12)
            }
            
            return image
        }
        
        public var identifier: String {
            return "com.github.semty/nuke/nsfw_image_processor?url=\(url.absoluteString)"
        }
        
        public var hashableIdentifier: AnyHashable {
            return self
        }
        
        public var description: String {
            return "NSFWImageProcessor(url: \(url.absoluteString)"
        }
        
        private func blur(image: UIImage, radius: Int) -> UIImage {
            let context = CIContext(options: nil)
            let blurFilter = CIFilter(name: "CIGaussianBlur")
            let ciImage = CIImage(image: image)
            blurFilter!.setValue(ciImage, forKey: kCIInputImageKey)
            blurFilter!.setValue(radius, forKey: kCIInputRadiusKey)
            
            let cropFilter = CIFilter(name: "CICrop")
            cropFilter!.setValue(blurFilter!.outputImage, forKey: kCIInputImageKey)
            cropFilter!.setValue(CIVector(cgRect: ciImage!.extent), forKey: "inputRectangle")
            
            let output = cropFilter!.outputImage
            let cgimg = context.createCGImage(output!, from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            return processedImage
        }
        
        private func detectNSFW(_ image: UIImage) -> (String, Double)? {
            print("NSFW DETECTION OF \(url.absoluteString) STARTED")
            let imageResized = image.square(scaledToSize: 224)
            guard let pixelBuffer = imageResized.toCVPixelBuffer() else {
                return nil
            }
            do {
                let nudity = Nudity()
                let output = try nudity.prediction(data: pixelBuffer)
                let classLabel = output.classLabel
                guard let prediction = output.prob[classLabel] else {
                    return nil
                }
                
                let nsfwString: String
                
                if (classLabel == "NSFW" && prediction >= .nsfwPredictionBorder)
                    || (classLabel == "SFW" && prediction <= .sfwPredictionBorder) {
                    nsfwString = "NSFW"
                } else {
                    nsfwString = "SFW"
                }
                
                print("NSFW DETECTION OF \(url.absoluteString) ENDED")
                return (nsfwString, prediction)
            } catch let err {
                print(err)
                return nil
            }
        }
    }
}

