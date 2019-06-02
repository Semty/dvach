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

final class ThreadWithImageView: UIView, ConfigurableView, ReusableView {

    typealias ConfigurationModel = Model
    
    // Model
    struct Model {
        let subjectTitle: String
        let commentTitle: String
        let dateTitle: String
        let threadImageThumbnail: String
    }
    
    // Outlets
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var threadImageView: UIImageView!
    @IBOutlet weak var threadView: UIView!
    
    // Layers
    private var viewShadowLayer: CAShapeLayer!
    
    // Variables
    private var cornerRadius: CGFloat = 12.0

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subjectLabel.textColor = .n1Gray
        commentLabel.textColor = .n2Gray
        dateLabel.textColor = .n5LightGray
        
        threadView.layer.cornerRadius = cornerRadius
        threadImageView.layer.cornerRadius = cornerRadius
        
        threadImageView.layer.borderColor = UIColor.n5LightGray.cgColor
        threadImageView.layer.borderWidth = 0.5
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
    
    func configure(with model: ThreadWithImageView.Model) {
        subjectLabel.text = model.subjectTitle
        commentLabel.text = model.commentTitle
        dateLabel.text = model.dateTitle
        downloadImage(withPath: model.threadImageThumbnail)
    }

    // MARK: - Private Image Downloading
    private func downloadImage(withPath path: String) {
        let thumbnailFullPath = "https://2ch.hk\(path)"
        if let url = URL(string: thumbnailFullPath) {
            Nuke.loadImage(
                with: url,
                options: ImageLoadingOptions(
                    transition: .fadeIn(duration: 0.5),
                    contentModes: .init(
                        success: .scaleAspectFill,
                        failure: .center,
                        placeholder: .center
                    )
                ),
                into: threadImageView
            )
        }
    }
}
