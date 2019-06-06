//
//  ThreadWithoutImageView.swift
//  dvach
//
//  Created by Ruslan Timchenko on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit

typealias ThreadWithoutImageCell = TableViewContainerCellBase<ThreadWithoutImageView>

final class ThreadWithoutImageView: UIView, ConfigurableView, ReusableView, PressStateAnimatable {
    
    typealias ConfigurationModel = Model
    
    // Model
    struct Model {
        let subjectTitle: String
        let commentTitle: String
        let dateTitle: String
    }
    
    // Outlets
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var threadView: UIView!
    
    // Layers
    private var viewShadowLayer: CAShapeLayer!

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        enablePressStateAnimation()
        subjectLabel.textColor = .n1Gray
        commentLabel.textColor = .n2Gray
        dateLabel.textColor = .n5LightGray
        
        threadView.layer.cornerRadius = 12
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if viewShadowLayer == nil {
            viewShadowLayer = CAShapeLayer()
            viewShadowLayer.addThreadShadow(aroundRoundedRect: threadView.frame)
            layer.insertSublayer(viewShadowLayer, at: 0)
        }
    }
    
    // MARK: - ConfigurableView
    
    func configure(with model: ThreadWithoutImageView.Model) {
        subjectLabel.text = model.subjectTitle
        commentLabel.text = model.commentTitle
        dateLabel.text = model.dateTitle
    }

}
