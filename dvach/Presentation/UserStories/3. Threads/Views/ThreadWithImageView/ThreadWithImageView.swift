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

public protocol NSFWDelegate: class {
    var nsfwData: [String: (isNSFW: String, confidence: Double)] { get set }
}

public protocol NSFWContainer {
    var nsfwDelegate: NSFWDelegate! { get set }
}

typealias ThreadWithImageCell = TableViewContainerCellBase<ThreadWithImageView>

final class ThreadWithImageView: UIView, ConfigurableView, ReusableView, NSFWContainer {

    typealias ConfigurationModel = Model
    
    // Delegate
    public weak var nsfwDelegate: NSFWDelegate!
    
    // Model
    struct Model {
        let subjectTitle: String
        let commentTitle: String
        let dateTitle: String
        let threadImageThumbnail: String
    }
    
    // Outlets
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var threadImageView: UIImageView!
    @IBOutlet weak var threadView: UIView!
    
    // Layers
    private var viewShadowLayer: CAShapeLayer!
    
    // Variables
    private var cornerRadius: CGFloat = 12.0
    private var thumbnailFullPath = ""

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
        self.thumbnailFullPath = thumbnailFullPath
        if let nsfwData = isThereSavedNSFWInfo() {
            if nsfwData.isNSFW == "SFW" {
                downloadWithoutBlur(nsfwData: nsfwData)
            } else {
                downloadWithBlur(checkNSFW: false, nsfwData: nsfwData)
            }
        } else {
            downloadWithBlur(checkNSFW: true, nsfwData: nil)
        }
    }
    
    private func isThereSavedNSFWInfo() -> (isNSFW: String, confidence: Double)? {
        guard let nsfwDelegate = nsfwDelegate else { return nil }
        guard let isNSFW = nsfwDelegate.nsfwData[thumbnailFullPath] else { return nil }
        return isNSFW
    }
    
    private func downloadWithBlur(checkNSFW: Bool,
                                  nsfwData: (isNSFW: String, confidence: Double)?) {
        if let url = URL(string: thumbnailFullPath) {
            let request = ImageRequest(url: url,
                                       processors: [ImageProcessor.GaussianBlur(radius: 12)])
            if !checkNSFW {
                Nuke.loadImage(with: request,
                               options: ImageLoadingOptions(
                                transition: .fadeIn(duration: 0.5),
                                contentModes: .init(
                                    success: .scaleAspectFill,
                                    failure: .center,
                                    placeholder: .center)
                    ),
                               into: threadImageView,
                               progress: nil) { [weak self] result in
                                if let nsfwData = nsfwData {
                                    switch result {
                                    case .success:
                                        DispatchQueue.main.async {
                                            self?.printNSFWConfidenceInTestLabel(with: nsfwData.isNSFW,
                                                                                 confidence: nsfwData.confidence)
                                        }
                                    case let .failure(error):
                                        print(error)
                                    }
                                }
                }
            } else {
                downloadWithBlur(checkNSFW: false, nsfwData: nsfwData)
                
                let request = ImageRequest(url: url)
                
                ImagePipeline.shared.loadImage(with: request,
                                               progress: nil)
                { [weak self] result in
                    switch result {
                    case let .success(response):
                        self?.handleNSFW(response: response,
                                         url: url)
                    case let .failure(error):
                        print(error)
                    }
                }
            }
        }
    }
    
    private func downloadWithoutBlur(nsfwData: (isNSFW: String, confidence: Double)) {
        if let url = URL(string: thumbnailFullPath) {
            Nuke.loadImage(with: url,
                           options: ImageLoadingOptions(
                            transition: .fadeIn(duration: 0.5),
                            contentModes: .init(
                                success: .scaleAspectFill,
                                failure: .center,
                                placeholder: .center)
                ),
                           into: threadImageView,
                           progress: nil) { [weak self] result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    self?.printNSFWConfidenceInTestLabel(with: nsfwData.isNSFW,
                                                                         confidence: nsfwData.confidence)
                                }
                            case let .failure(error):
                                print(error)
                            }
            }
        }
    }
    
    private func handleNSFW(response: ImageResponse, url: URL) {
        GlobalUtils.backgroundNSFWDetectionQueue.async { [weak self] in
            guard let self = self else { return }
            NSFWDetector.shared.predictNSFW(response.image,
                                            url: url,
                                            completion:
                { [weak self] nsfwResponse in
                    guard let nsfwResponse = nsfwResponse else { return }
                    guard let self = self else { return }
                    
                    let nsfwString = nsfwResponse.0
                    let nsfwConfidence = nsfwResponse.1
                    
                    DispatchQueue.main.async {
                        self.nsfwDelegate.nsfwData.updateValue((nsfwString, nsfwConfidence), forKey: self.thumbnailFullPath)
                        self.printNSFWConfidenceInTestLabel(with: nsfwString,
                                                            confidence: nsfwResponse.1)
                        if nsfwString == "SFW" {
                            self.downloadWithoutBlur(nsfwData: (nsfwString, nsfwConfidence))
                        }
                    }
            })
        }
    }
    
    private func printNSFWConfidenceInTestLabel(with nsfwString: String,
                                                confidence: Double) {
        self.confidenceLabel.text = String(format: "%@ %f",
                                           arguments: [nsfwString, confidence])
    }
}
