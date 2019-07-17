//
//  Extension+UIImage.swift
//  FatFood
//
//  Created by Kirill Solovyov on 09.09.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UIImage {
    
    public func square(scaledToSize newSize: CGFloat) -> UIImage {
        var scaleTransform: CGAffineTransform
        var origin: CGPoint
        var image = self
        if image.size.width > image.size.height {
            let scaleRatio: CGFloat = newSize / image.size.height
            scaleTransform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
            origin = CGPoint(x: -(image.size.width - image.size.height) / 2.0, y: 0)
        }
        else {
            let scaleRatio: CGFloat = newSize / image.size.width
            scaleTransform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
            origin = CGPoint(x: 0, y: -(image.size.height - image.size.width) / 2.0)
        }
        let size = CGSize(width: newSize, height: newSize)
        if image.size.width > image.size.height {
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
        }
        else {
            UIGraphicsBeginImageContext(size)
        }
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.concatenate(scaleTransform)
        image.draw(at: origin)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    public func toCVPixelBuffer() -> CVPixelBuffer? {
        let image = self
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        if let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            
            context?.translateBy(x: 0, y: image.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            
            UIGraphicsPushContext(context!)
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            
            return pixelBuffer
        }
        
        return nil
    }
}
