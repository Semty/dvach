//
//  DTPhotoCollectionViewCell.swift
//  dvach
//
//  Created by Ruslan Timchenko on 18/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit
import AVKit
import FLAnimatedImage

public protocol DTPhotoCollectionViewCellDelegate: NSObjectProtocol {
    func collectionViewCellDidZoomOnPhoto(_ cell: DTPhotoCollectionViewCell, atScale scale: CGFloat)
    func collectionViewCellWillZoomOnPhoto(_ cell: DTPhotoCollectionViewCell)
    func collectionViewCellDidEndZoomingOnPhoto(_ cell: DTPhotoCollectionViewCell, atScale scale: CGFloat)
    func shouldOpenMediaFile(url: URL?, type: DTMediaViewerController.MediaFile.MediaType)
}

open class DTPhotoCollectionViewCell: UICollectionViewCell {
    public private(set) var scrollView: DTScrollView!
    public private(set) var imageView: FLAnimatedImageView!
    
    // Open in browser button
    private lazy var button: BottomButton = {
        let button = BottomButton()
        let model = BottomButton.Model(text: "Открыть фото в браузере",
                                       backgroundColor: .white,
                                       textColor: .black)
        button.configure(with: model)
        button.isHidden = true
        button.enablePressStateAnimation { [weak self] in
            self?.delegate?.shouldOpenMediaFile(url: self?.url,
                                                type: .image)
        }
        return button
    }()
    
    private var xOffset: CGFloat = -1
    
    // default is 1.0
    open var minimumZoomScale: CGFloat = 1.0 {
        willSet {
            if imageView.image == nil {
                scrollView.minimumZoomScale = 1.0
            } else {
                scrollView.minimumZoomScale = newValue
            }
        }
        
        didSet {
            correctCurrentZoomScaleIfNeeded()
        }
    }
    
    // default is 3.0.
    open var maximumZoomScale: CGFloat = 3.0 {
        willSet {
            if imageView.image == nil {
                scrollView.maximumZoomScale = 1.0
            } else {
                scrollView.maximumZoomScale = newValue
            }
        }
        
        didSet {
            correctCurrentZoomScaleIfNeeded()
        }
    }
    
    // Media File URL
    private var url: URL?
    
    // Delegate
    weak var delegate: DTPhotoCollectionViewCellDelegate?
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        scrollView = DTScrollView(frame: CGRect.zero)
        scrollView.minimumZoomScale = minimumZoomScale
        scrollView.maximumZoomScale = 1.0 // Not allow zooming when there is no image
        
        let imageView = DTImageView(frame: CGRect.zero)
        // Layout subviews every time getting new image
        imageView.imageChangeBlock = { [weak self] (image: UIImage?) -> Void in
            // Update image frame whenever image changes
            if let strongSelf = self {
                if image == nil {
                    strongSelf.scrollView.minimumZoomScale = 1.0
                    strongSelf.scrollView.maximumZoomScale = 1.0
                } else {
                    strongSelf.scrollView.minimumZoomScale = strongSelf.minimumZoomScale
                    strongSelf.scrollView.maximumZoomScale = strongSelf.maximumZoomScale
                    strongSelf.setNeedsLayout()
                }
                strongSelf.correctCurrentZoomScaleIfNeeded()
            }
        }
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        scrollView.delegate = self
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        setupButton()
    }
    
    private func setupButton() {
        addSubview(button)
        let inset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : .inset16
        button.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(inset)
            $0.bottom.equalToSuperview().inset(CGFloat.inset8)
        }
    }
    
    private func correctCurrentZoomScaleIfNeeded() {
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
        
        if scrollView.zoomScale > scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.maximumZoomScale
        }
    }
    
    // Overridden
    override open func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        button.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(safeAreaInsets.bottom + CGFloat.inset8)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        resizeUI()
    }
    
    private func resizeUI() {
        
        if !UIDevice.current.isPortrait
            && scrollView.zoomScale != minimumZoomScale
            && xOffset == frame.origin.x {
            return
        }
        
        // Set the aspect ratio of the image
        if let image = imageView.image {
            
            scrollView.zoomScale = 1.0
            xOffset = frame.origin.x
            
            let rect = AVMakeRect(aspectRatio: image.size, insideRect: bounds)
            //Then figure out offset to center vertically or horizontally
            let x = (scrollView.frame.width - rect.width) / 2
            let y = (scrollView.frame.height - rect.height) / 2
            
            imageView.frame = CGRect(x: x, y: y, width: rect.width, height: rect.height)
            scrollView.contentSize = imageView.frame.size
        }
    }
    
    // MARK: - Configuration
    
    public func configure(_ image: UIImage?, urlPath: String?) {
        if let urlPath = urlPath, let image = image {
            url = URL(string: "\(GlobalUtils.base2chPath)\(urlPath)")
            if !image.isNFFW {
                ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
                imageView.loadImage(url: urlPath,
                                    defaultImage: image,
                                    placeholder: image,
                                    transition: false,
                                    checkNSFW: false)
            } else {
                imageView.image = image
                button.isHidden = false
            }
        } else {
            imageView.image = image
        }
    }
}

// MARK: - UIScrollViewDelegate

extension DTPhotoCollectionViewCell: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.collectionViewCellWillZoomOnPhoto(self)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageViewFrameForSize(frame.size)
        
        delegate?.collectionViewCellDidZoomOnPhoto(self, atScale: scrollView.zoomScale)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegate?.collectionViewCellDidEndZoomingOnPhoto(self, atScale: scale)
    }
    
    fileprivate func updateImageViewFrameForSize(_ size: CGSize) {
        
        let y = max(0, (size.height - imageView.frame.height) / 2)
        let x = max(0, (size.width - imageView.frame.width) / 2)
        
        imageView.frame.origin = CGPoint(x: x, y: y)
    }
}
