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
    
    public func createCloseButton(completion: @escaping () -> Void) -> CloseButton {
        let button = CloseButton()
        button.enableTapping(completion)
        return button
    }
}
