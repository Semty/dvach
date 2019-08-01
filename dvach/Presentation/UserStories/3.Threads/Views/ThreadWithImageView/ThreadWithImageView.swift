//
//  ThreadWithImageView.swift
//  dvach
//
//  Created by Ruslan Timchenko on 01/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import UIKit
import Nuke

typealias ThreadWithImageCell = TableViewContainerCellBase<ThreadWithImageView>

final class ThreadWithImageView: UIView, ConfigurableView, ReusableView, PressStateAnimatable {

    typealias ConfigurationModel = Model
    
    // Model
    struct Model {
        let subjectTitle: String
        let commentTitle: String
        let postsCountTitle: String
        let threadImageThumbnail: String
        let id: String
        let isSafeMode: Bool
        
        var description: String {
            return "\(id)\n\(commentTitle)\n\(subjectTitle)\n\(threadImageThumbnail)"
        }
    }
    
    // Outlets
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var threadImageView: UIImageView!
    @IBOutlet weak var threadView: UIView!
    
    // Constraints
    @IBOutlet weak var commentLabelTopConstraint: NSLayoutConstraint!
    
    // Layers
    private var viewShadowLayer: CAShapeLayer!
    
    // Variables
    private var cornerRadius: CGFloat = 12.0

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        enablePressStateAnimation()
        subjectLabel.textColor = .n1Gray
        commentLabel.textColor = .n1Gray
        postsCountLabel.textColor = .n7Blue
        
        threadView.layer.cornerRadius = cornerRadius
        threadImageView.layer.cornerRadius = cornerRadius
        
        threadImageView.layer.borderColor = UIColor.n5LightGray.cgColor
        threadImageView.layer.borderWidth = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if viewShadowLayer == nil {
            viewShadowLayer = CAShapeLayer()
            layer.insertSublayer(viewShadowLayer, at: 0)
        }
        
        viewShadowLayer.addThreadShadow(aroundRoundedRect: threadView.frame)
    }
    
    // MARK: - ConfigurableView
    
    func configure(with model: ThreadWithImageView.Model) {
        subjectLabelValueWillBeChanged(with: model.subjectTitle)
        subjectLabel.text = model.subjectTitle
        commentLabel.text = model.commentTitle
        postsCountLabel.text = model.postsCountTitle
        threadImageView.loadImage(url: model.threadImageThumbnail, isSafeMode: model.isSafeMode)
    }
    
    // MARK: - ReusableView
    
    func prepareForReuse() {
        subjectLabel.text = nil
        commentLabel.text = nil
        postsCountLabel.text = nil
        threadImageView.image = nil
    }
}

// MARK: - Constraints Configuration

extension ThreadWithImageView {
    fileprivate func subjectLabelValueWillBeChanged(with value: String) {
        if value == "" {
            subjectLabel.isHidden = true
            commentLabelTopConstraint.constant = 8.0
        } else {
            subjectLabel.isHidden = false
            commentLabelTopConstraint.constant = 49.0
        }
    }
}
