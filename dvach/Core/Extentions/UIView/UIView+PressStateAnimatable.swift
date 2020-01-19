//
//  UIView+PressStateAnimatable.swift
//  dvach
//
//  Created by Kirill Solovyov on 04/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit

private extension CGFloat {
    static var defaultScale: CGFloat {
        let device = UIDevice.current
        
        switch device.userInterfaceIdiom {
        case .pad:
//            switch device.orientation {
//            case .portrait, .portraitUpsideDown:
//                return 0.985
//            case .landscapeLeft, .landscapeRight:
//                return 0.995
//            default: return 0.985
//            }
            return 0.99
        case .phone:
//            switch device.orientation {
//            case .portrait, .portraitUpsideDown:
//                return 0.96
//            case .landscapeLeft, .landscapeRight:
//                return 0.98
//            default: return 0.96
//            }
            return 0.96
        default: return 0.96
        }
    }
}

public enum GestureRecognizerType {
    case `default`
    case nonScrollable
}

public protocol PressStateAnimatable: class, RecognizerDeletable {
    /// Включение зуммирования при нажатии на UIView с минимальным зумом minScale (от 0.0 до 1.0) и длительностью duration
    func enablePressStateAnimation(minScale: CGFloat,
                                   duration: TimeInterval,
                                   recognizerType: GestureRecognizerType)
    
    /// Включение зуммирования при нажатии на UIView с минимальным зумом minScale (от 0.0 до 1.0),
    /// длительностью duration и с вызовом блоков touchesBeganBlock при начале нажатия и touchesEndedBlock при конце нажатия
    func enablePressStateAnimation(minScale: CGFloat, duration: TimeInterval,
                                   recognizerType: GestureRecognizerType,
                                   touchesBeganBlock: ((_ beganGesture: UIGestureRecognizer) -> Void)?,
                                   touchesEndedBlock: ((_ endedGesture: UIGestureRecognizer) -> Void)?)
    
    /// Включение зуммирования при нажатии на pressingView с минимальным зумом minScale (от 0.0 до 1.0),
    /// длительностью duration и с вызовом блоков touchesBeganBlock при начале нажатия и touchesEndedBlock при конце нажатия
    func enablePressStateAnimation(pressingView: (UIView & RecognizerDeletable),
                                   minScale: CGFloat,
                                   duration: TimeInterval,
                                   recognizerType: GestureRecognizerType,
                                   touchesBeganBlock: ((_ beganGesture: UIGestureRecognizer) -> Void)?,
                                   touchesEndedBlock: ((_ endedGesture: UIGestureRecognizer) -> Void)?)
    
    /// Выключение зуммирования при нажатии на UIView
    func disablePressStateAnimation()
    
    /// Выключение зуммирования при нажатии на pressingView
    func disablePressStateAnimation(from pressingView: (UIView & RecognizerDeletable))
    
    /// Производит анимацию нажатия UIView с минимальным зумом minScale (от 0.0 до 1.0) и длительностью duration
    /// (использовать когда touches до UIView не проходят,
    /// например, если она лежит под другой UIView, иначе использовать enablePressStateAnimation(minScale:duration:)
    func animatePressStateChange(pressed: Bool, minScale: CGFloat, duration: TimeInterval)
    
    /// Включение зуммирования при нажатии на UIView с минимальным зумом minScale 0.95 и длительностью 0.2
    func enablePressStateAnimation()
    
    /// Включение зуммирования при нажатии на UIView с действием
    func enablePressStateAnimation(actionBlock: (() -> Void)?)
}

extension PressStateAnimatable where Self: UIView {
    
    typealias GestureHandler = (UIGestureRecognizer) -> Void
    
    public func enablePressStateAnimation() {
        enablePressStateAnimation(actionBlock: nil)
    }
    
    public func enablePressStateAnimation(actionBlock: (() -> Void)?) {
        enablePressStateAnimation(minScale: .defaultScale,
                                  duration: 0.2,
                                  touchesBeganBlock: nil,
                                  touchesEndedBlock: { _ in actionBlock?() })
    }
    
    public func enablePressStateAnimation(minScale: CGFloat, duration: TimeInterval, recognizerType: GestureRecognizerType = .default) {
        enablePressStateAnimation(minScale: minScale,
                                  duration: duration,
                                  recognizerType: recognizerType,
                                  touchesBeganBlock: nil,
                                  touchesEndedBlock: nil)
    }
    
    public func enablePressStateAnimation(minScale: CGFloat,
                                          duration: TimeInterval,
                                          recognizerType: GestureRecognizerType = .default,
                                          touchesBeganBlock: ((_ beganGesture: UIGestureRecognizer) -> Void)?,
                                          touchesEndedBlock: ((_ endedGesture: UIGestureRecognizer) -> Void)?) {
        
        enablePressStateAnimation(pressingView: self,
                                  minScale: minScale,
                                  duration: duration,
                                  recognizerType: recognizerType,
                                  touchesBeganBlock: touchesBeganBlock,
                                  touchesEndedBlock: touchesEndedBlock)
    }
    
    public func enablePressStateAnimation(pressingView: (UIView & RecognizerDeletable),
                                          minScale: CGFloat,
                                          duration: TimeInterval,
                                          recognizerType: GestureRecognizerType = .default,
                                          touchesBeganBlock: ((_ beganGesture: UIGestureRecognizer) -> Void)?,
                                          touchesEndedBlock: ((_ endedGesture: UIGestureRecognizer) -> Void)?) {
        
        let handler: GestureHandler? = { [weak self] gesture in
            self?.handleGesture(gesture,
                                minScale: minScale,
                                duration: duration,
                                touchesBeganBlock: touchesBeganBlock,
                                touchesEndedBlock: touchesEndedBlock)
        }
        
        var gestureRecognizer: UIGestureRecognizer
        switch recognizerType {
        case .default:
            gestureRecognizer = HighlightingGestureRecognizer(handler: handler)
        case .nonScrollable:
            gestureRecognizer = HighlightingNonScrollableGestureRecognizer(handler: handler)
        }
        
        // Удаление Recognizer если он уже был
        _ = pressingView.deleteRecognizer(recognizerClass: type(of: gestureRecognizer))
        
        gestureRecognizer.cancelsTouchesInView = false
        pressingView.addGestureRecognizer(gestureRecognizer)
    }
    
    public func animatePressStateChange(pressed: Bool, minScale: CGFloat, duration: TimeInterval) {
        var minScale = minScale
        guard minScale < 1.0 else { return }
        if minScale < 0.0 {
            minScale = 0.0
        }
        let toValue = pressed ? CATransform3DMakeScale(minScale, minScale, 1) : CATransform3DMakeScale(1, 1, 1)
        var duration = duration
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        if let presentationLayer = layer.presentation() {
            
            // Процент выполнения текущей анимации
            let animationProgress: Double = Double((presentationLayer.transform.m11 - minScale) / (1 - minScale))
            scaleAnimation.fromValue = presentationLayer.transform
            
            // Если вью не нажата, то анимация в обратную сторону
            duration = pressed ? duration * animationProgress : duration * (1 - animationProgress)
        } else {
            scaleAnimation.fromValue = layer.transform
        }
        scaleAnimation.toValue = toValue
        scaleAnimation.duration = duration
        
        // Удаление предыдущей анимации, если она ещё выполняется
        layer.removeAnimation(forKey: "scale")
        layer.add(scaleAnimation, forKey: "scale")
        layer.transform = toValue
    }
    
    public func disablePressStateAnimation() {
        disablePressStateAnimation(from: self)
    }
    
    public func disablePressStateAnimation(from pressingView: (UIView & RecognizerDeletable)) {
        _ = pressingView.deleteRecognizer(recognizerClass: HighlightingGestureRecognizer.self)
    }
    
    // MARK: - Private
    
    private func handleGesture(_ gesture: UIGestureRecognizer,
                               minScale: CGFloat,
                               duration: TimeInterval,
                               touchesBeganBlock: ((_ beganGesture: UIGestureRecognizer) -> Void)?,
                               touchesEndedBlock: ((_ endedGesture: UIGestureRecognizer) -> Void)?) {
        switch gesture.state {
        case .possible, .changed:
            break
        case .began:
            touchesBeganBlock?(gesture)
            self.animatePressStateChange(pressed: true, minScale: minScale, duration: duration)
        case .ended:
            touchesEndedBlock?(gesture)
            fallthrough
        case .cancelled, .failed:
            self.animatePressStateChange(pressed: false, minScale: minScale, duration: duration)
        @unknown default:
            print("handle gesture ERRORRO!!!!!")
        }
    }
}

final class PressStateAnimatableView: UIView, PressStateAnimatable {}
