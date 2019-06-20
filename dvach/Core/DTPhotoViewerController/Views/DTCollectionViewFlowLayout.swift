//
//  DTCollectionViewFlowLayout.swift
//  dvach
//
//  Created by Ruslan Timchenko on 18/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit

class DTCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var currentIndex: Int?
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        invalidateLayout()
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let index = currentIndex, let collectionView = collectionView {
            currentIndex = nil
            return CGPoint(x: CGFloat(index) * collectionView.frame.size.width, y: 0)
        }
        
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
}
