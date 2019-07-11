//
//  StackViewContainer.swift
//  Receipt
//
//  Created by Kirill Solovyov on 23.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation

import UIKit

public protocol IStackViewContainer {
    
    func addView(_ view: UIView)
    func removeView(_ view: UIView)
    func insertView(_ view: UIView, at index: Int)
    func replaceView(_ oldView: UIView, with newView: UIView)
    func removeAllViews()
    
    static func emptyView(withHeight height: CGFloat) -> UIView
    static func emptyView(withHeight height: CGFloat, heightPriority: UILayoutPriority) -> UIView
    
    var numberOfViews: Int { get }
}

final public class StackViewContainer: TPKeyboardAvoidingScrollView, IStackViewContainer, NibAwakable {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet var placeholderView: UIView!
    @IBOutlet private weak var additionalSpaceHeighEqualConstraint: NSLayoutConstraint!
    
    public var shouldAvoidContentInsetTouches = false
    public var shouldFillRemainingSpace: Bool {
        set {
            guard shouldFillRemainingSpace != newValue else { return }
            if newValue {
                stackView.insertArrangedSubview(placeholderView, at: numberOfViews)
            } else {
                placeholderView.removeFromSuperview()
            }
        }
        get {
            return placeholderView.superview != nil
        }
    }
    
    /// Определяет должен ли скролл bounce-иться с контентом меньше размеров экрана
    public var shouldBounceAlways = true {
        didSet {
            updateHeighEqualConstraint()
        }
    }
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var checkPoint = point
        if shouldAvoidContentInsetTouches {
            checkPoint.y += min(0, contentOffset.y)
        }
        return super.point(inside: checkPoint, with: event)
    }
    
    public func placeController(_ controller: IChildViewController, isHidden: Bool = false) {
        guard let parentViewController = firstAvailableUIViewController() else { assert(false); return }
        
        parentViewController.addChildViewController(controller)
        self.addView(controller.view)
        controller.didMove(toParent: controller.parent)
        controller.view.isHidden = isHidden
    }
    
    public func addView(_ view: UIView) {
        self.stackView.insertArrangedSubview(view, at: numberOfViews)
    }
    
    public func removeView(_ view: UIView) {
        view.removeFromSuperview()
    }
    
    public func removeAllViews() {
        for view in stackView.arrangedSubviews where view != placeholderView {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    public func insertView(_ view: UIView, at index: Int) {
        guard index <= numberOfViews else {
            //            logWarning("⚠️ Trying to replace blank view")
            return
        }
        self.stackView.insertArrangedSubview(view, at: index)
    }
    
    public func replaceView(_ oldView: UIView, with newView: UIView) {
        guard let indexOfOld = self.stackView.arrangedSubviews.firstIndex(of: oldView) else {
            //            logWarning("⚠️ View to replace is not present in StackView")
            return
        }
        if let indexOfNew = self.stackView.arrangedSubviews.firstIndex(of: newView) {
            self.stackView.exchangeSubview(at: indexOfOld, withSubviewAt: indexOfNew)
        } else {
            self.stackView.insertArrangedSubview(newView, at: indexOfOld)
            oldView.removeFromSuperview()
        }
        
    }
    
    public static func emptyView(withHeight height: CGFloat) -> UIView {
        return emptyView(withHeight: height, heightPriority: UILayoutPriority.defaultHigh)
    }
    
    public static func emptyView(withHeight height: CGFloat, heightPriority: UILayoutPriority) -> UIView {
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        emptyView.frame.size.height = height
        emptyView.autoSetDimension(.height, toSize: height, priority: heightPriority)
        return emptyView
    }
    
    public var numberOfViews: Int {
        if shouldFillRemainingSpace {
            return self.stackView.arrangedSubviews.count - 1
        }
        return self.stackView.arrangedSubviews.count
    }
    
    override public func awakeAfter(using aDecoder: NSCoder) -> Any? {
        super.awakeAfter(using: aDecoder)
        return awakeAfterCoder()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        contentInsetAdjustmentBehavior = .automatic
    }
    
    override public var contentInset: UIEdgeInsets {
        didSet {
            updateHeighEqualConstraint()
            scrollIndicatorInsets.top = contentInset.top
        }
    }
    
    private func updateHeighEqualConstraint() {
        var newValue = -(contentInset.top + contentInset.bottom)
        if shouldBounceAlways {
            newValue += 1
        }

        additionalSpaceHeighEqualConstraint.constant = newValue
    }
}
