//
//  ComponentsFactory.swift
//  Receipt
//
//  Created by Kirill Solovyov on 22.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

public final class ComponentsFactory: IComponentsFactory {
    
    public func createStackViewContainer() -> StackViewContainer {
        return StackViewContainer.fromNib()
    }
    
    public func createShadowViewContainer(with contentView: UIView, insets: UIEdgeInsets) -> ShadowViewContainer {
        let container = ShadowViewContainer(insets: insets)
        container.contentView = contentView
        
        return container
    }
    
    public func createContentContainer(content: UIView) -> UIView {
        return ContantContainer(contantView: content)
    }
    
    public func createEmptyView(height: CGFloat) -> UIView {
        let view = UIView()
        view.autoSetDimension(.height, toSize: height)
        
        return view
    }
    
    public func createCloseButton(style: CloseButton.Style,
                                  imageColor: UIColor?,
                                  backgroundColor: UIColor?,
                                  completion: @escaping () -> Void) -> CloseButton {
        let button = CloseButton(style: style, imageColor: imageColor, backgroundColor: backgroundColor)
        button.enableTapping(completion)
        return button
    }
    
    public func createHorizontalMoreButton(_ color: UIColor?, completion: @escaping () -> Void) -> HorizontalMoreButton {
        let button = HorizontalMoreButton(color)
        button.enableTapping(completion)
        return button
    }
    
    public func createBlockWithTitle() -> BlockWithTitle {
        return BlockWithTitle.fromNib()
    }
}
