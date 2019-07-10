//
//  Extension+UIImage.swift
//  FatFood
//
//  Created by Kirill Solovyov on 09.09.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

extension UIImage {
    
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return img
    }
    
    static func icon(boardId: String) -> UIImage {
        let icon: UIImage
        if let assetsIcon = UIImage(named: boardId) {
            icon = assetsIcon
        } else {
            icon = UIImage(named: "default") ?? UIImage()
        }
        return icon
    }
    
    static func preferredImageSize(for size: CGSize, with aspectRatio: CGFloat) -> CGSize {
        guard aspectRatio != 1.0 else {
            return CGSize(width: size.height, height: size.height)
        }
        
        let widthDifference = abs(size.width - size.height * aspectRatio) // /
        let heightDiffence = abs(size.height - size.width / aspectRatio)  // *
        
        if widthDifference < heightDiffence {
            return CGSize(width: size.height * aspectRatio, height: size.height)
        } else if widthDifference > heightDiffence {
            return CGSize(width: size.width, height: size.width / aspectRatio)
        } else {
            // If can not determine which difference is greater then the returned size should be based on the specified height
            return CGSize(width: heightDiffence * aspectRatio, height: size.height)
        }
    }
    
    func croppedInRect(rect: CGRect) -> UIImage {
        func rad(_ degree: Double) -> CGFloat {
            return CGFloat(degree / 180.0 * .pi)
        }
        
        var rect = rect
        
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .right, .left:
            rectTransform = .identity
            rect.size.height = self.size.width
            rect.size.width = self.size.height
        case .down:
            rectTransform = CGAffineTransform.identity
            rect.origin.x = self.size.width - (rect.size.width + rect.origin.x)
            rect.origin.y = self.size.height - (rect.size.height + rect.origin.y)
        default:
            rectTransform = .identity
        }
        rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale)
        
        let imageRef = self.cgImage!.cropping(to: rect.applying(rectTransform))
        let result = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return result
    }

    // MARK: - Icons
    
    /// More action icon. Aspect ratio 4:1
    static func moreIcon(size: CGSize, color fillColor: UIColor!) -> UIImage {
        let aspectRatio: CGFloat = 4.0
        let preferredSize = UIImage.preferredImageSize(for: size, with: aspectRatio)
        let frame = CGRect(x: 0, y: 0, width: preferredSize.width, height: preferredSize.height)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        //PaintCode here
        let morePath = UIBezierPath()
        morePath.move(to: CGPoint(x: frame.minX + 0.12500 * frame.width, y: frame.minY + 0.00000 * frame.height))
        morePath.addLine(to: CGPoint(x: frame.minX + 0.12500 * frame.width, y: frame.minY + 0.00000 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.25000 * frame.width, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.19404 * frame.width, y: frame.minY + 0.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.25000 * frame.width, y: frame.minY + 0.22386 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.12500 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.25000 * frame.width, y: frame.minY + 0.77614 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.19404 * frame.width, y: frame.minY + 1.00000 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.05596 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.77614 * frame.height))
        morePath.addLine(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.12500 * frame.width, y: frame.minY + 0.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.22386 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.05596 * frame.width, y: frame.minY + 0.00000 * frame.height))
        morePath.close()
        morePath.move(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.00000 * frame.height))
        morePath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.00000 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.62500 * frame.width, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.56904 * frame.width, y: frame.minY + 0.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.62500 * frame.width, y: frame.minY + 0.22386 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.62500 * frame.width, y: frame.minY + 0.77614 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.56904 * frame.width, y: frame.minY + 1.00000 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.37500 * frame.width, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.43096 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.37500 * frame.width, y: frame.minY + 0.77614 * frame.height))
        morePath.addLine(to: CGPoint(x: frame.minX + 0.37500 * frame.width, y: frame.minY + 0.50000 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.37500 * frame.width, y: frame.minY + 0.22386 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.43096 * frame.width, y: frame.minY + 0.00000 * frame.height))
        morePath.close()
        morePath.move(to: CGPoint(x: frame.minX + 0.87500 * frame.width, y: frame.minY + 0.00000 * frame.height))
        morePath.addLine(to: CGPoint(x: frame.minX + 0.87500 * frame.width, y: frame.minY + 0.00000 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.94404 * frame.width, y: frame.minY + 0.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.22386 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.87500 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 1.00000 * frame.width, y: frame.minY + 0.77614 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.94404 * frame.width, y: frame.minY + 1.00000 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.75000 * frame.width, y: frame.minY + 0.50000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.80596 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.75000 * frame.width, y: frame.minY + 0.77614 * frame.height))
        morePath.addLine(to: CGPoint(x: frame.minX + 0.75000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        morePath.addCurve(to: CGPoint(x: frame.minX + 0.87500 * frame.width, y: frame.minY + 0.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.75000 * frame.width, y: frame.minY + 0.22386 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.80596 * frame.width, y: frame.minY + 0.00000 * frame.height))
        morePath.close()
        morePath.usesEvenOddFillRule = true
        fillColor.setFill()
        morePath.fill()
        
        //swiftlint:disable force_unwrapping
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// Cancel X icon. Aspect ratio 1:1
    static func cancelIcon(size: CGSize, color fillColor: UIColor) -> UIImage {
        let aspectRatio: CGFloat = 1.0
        let preferredSize = UIImage.preferredImageSize(for: size, with: aspectRatio)
        let frame = CGRect(x: 0, y: 0, width: preferredSize.width, height: preferredSize.height)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        /// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.08337 * frame.width, y: frame.minY + 0.99873 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.08334 * frame.width, y: frame.minY + 0.99873 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.91546 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.03731 * frame.width, y: frame.minY + 0.99873 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.96145 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.02441 * frame.width, y: frame.minY + 0.85658 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.00000 * frame.width, y: frame.minY + 0.89338 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.00878 * frame.width, y: frame.minY + 0.87220 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.38352 * frame.width, y: frame.minY + 0.49754 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.03062 * frame.width, y: frame.minY + 0.14184 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.03102 * frame.width, y: frame.minY + 0.14227 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.03308 * frame.width, y: frame.minY + 0.02457 * frame.height), controlPoint1: CGPoint(x: frame.minX + -0.00094 * frame.width, y: frame.minY + 0.10920 * frame.height), controlPoint2: CGPoint(x: frame.minX + -0.00002 * frame.width, y: frame.minY + 0.05651 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.14881 * frame.width, y: frame.minY + 0.02457 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.06536 * frame.width, y: frame.minY + -0.00658 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.11653 * frame.width, y: frame.minY + -0.00658 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.50126 * frame.width, y: frame.minY + 0.37985 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.85673 * frame.width, y: frame.minY + 0.02437 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.85673 * frame.width, y: frame.minY + 0.02437 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.97451 * frame.width, y: frame.minY + 0.02437 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.88925 * frame.width, y: frame.minY + -0.00812 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.94198 * frame.width, y: frame.minY + -0.00812 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.97451 * frame.width, y: frame.minY + 0.14206 * frame.height), controlPoint1: CGPoint(x: frame.minX + 1.00703 * frame.width, y: frame.minY + 0.05687 * frame.height), controlPoint2: CGPoint(x: frame.minX + 1.00703 * frame.width, y: frame.minY + 0.10956 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.61868 * frame.width, y: frame.minY + 0.49797 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.97451 * frame.width, y: frame.minY + 0.85683 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.97456 * frame.width, y: frame.minY + 0.85689 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.97662 * frame.width, y: frame.minY + 0.97458 * frame.height), controlPoint1: CGPoint(x: frame.minX + 1.00766 * frame.width, y: frame.minY + 0.88882 * frame.height), controlPoint2: CGPoint(x: frame.minX + 1.00858 * frame.width, y: frame.minY + 0.94152 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.85883 * frame.width, y: frame.minY + 0.97664 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.94466 * frame.width, y: frame.minY + 1.00765 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.89193 * frame.width, y: frame.minY + 1.00857 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.85678 * frame.width, y: frame.minY + 0.97458 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.85814 * frame.width, y: frame.minY + 0.97597 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.85745 * frame.width, y: frame.minY + 0.97528 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.50079 * frame.width, y: frame.minY + 0.61562 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.14218 * frame.width, y: frame.minY + 0.97420 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.14188 * frame.width, y: frame.minY + 0.97450 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.08337 * frame.width, y: frame.minY + 0.99873 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.12635 * frame.width, y: frame.minY + 0.99002 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.10533 * frame.width, y: frame.minY + 0.99873 * frame.height))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        fillColor.setFill()
        bezierPath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func backIcon(size: CGSize, color fillColor: UIColor) -> UIImage {
        let aspectRatio: CGFloat = 1.0
        let preferredSize = UIImage.preferredImageSize(for: size, with: aspectRatio)
        let frame = CGRect(x: 0, y: 0, width: preferredSize.width, height: preferredSize.height)

        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Subframes
        let group: CGRect = CGRect(x: frame.minX + fastFloor(frame.width * 0.31250 + 0.5), y: frame.minY + fastFloor(frame.height * 0.14062 + 0.5), width: fastFloor(frame.width * 0.67188 + 0.5) - fastFloor(frame.width * 0.31250 + 0.5), height: fastFloor(frame.height * 0.85938 + 0.5) - fastFloor(frame.height * 0.14062 + 0.5))
        
        //// Group
        //// back Drawing
        let backPath = UIBezierPath()
        backPath.move(to: CGPoint(x: group.minX + 1.00000 * group.width, y: group.minY + 0.00000 * group.height))
        backPath.addLine(to: CGPoint(x: group.minX + 0.00000 * group.width, y: group.minY + 0.50000 * group.height))
        backPath.addLine(to: CGPoint(x: group.minX + 1.00000 * group.width, y: group.minY + 1.00000 * group.height))
        fillColor.setStroke()
        backPath.lineWidth = 2
        backPath.lineCapStyle = .round
        backPath.lineJoinStyle = .round
        backPath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}
