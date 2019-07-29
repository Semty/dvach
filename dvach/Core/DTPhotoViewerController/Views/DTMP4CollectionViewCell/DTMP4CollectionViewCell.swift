//
//  DTMP4CollectionViewCell.swift
//  dvach
//
//  Created by Ruslan Timchenko on 07/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import AVKit
import VersaPlayer

open class DTMP4CollectionViewCell: UICollectionViewCell, VideoContainer {

    public var snapshotCropNeeded = false
    
    // Player View (WebM Only!)
    public private(set) weak var playerView: VersaPlayerView?
    // Private NSFW preview Image View
    private weak var imageView: UIImageView?
    
    private var playerItemView: VersaPlayerItem?
    private lazy var playerControlsView = VersaPlayerControls.fromNib(.main)
    
    // Open in browser button
    private lazy var button: BottomButton = {
        let button = BottomButton()
        let model = BottomButton.Model(text: "Открыть видео в браузере",
                                       backgroundColor: .white, textColor: .black)
        button.configure(with: model)
        button.isHidden = true
        button.enablePressStateAnimation { [weak self] in
            self?.delegate?.shouldOpenMediaFile(url: self?.url,
                                                type: .mp4)
        }
        return button
    }()
    
    // NSFW Flag
    private var isNSFW = true
    
    // Media File URL
    private var url: URL?
    
    // Delegate
    public weak var delegate: VideoContainerDelegate?
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
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
        resizeImageView()
    }

    // MARK: - Setup UI
    
    private func setupPlayerView() {
        if playerView == nil {
            let playerView = VersaPlayerView(frame: bounds)
            playerView.playbackDelegate = self
            addSubview(playerView)
            playerView.snp.makeConstraints { $0.edges.equalToSuperview() }
            
            playerView.layer.backgroundColor = UIColor.black.cgColor
            
            playerView.use(controls: playerControlsView)
            playerControlsView.snp.makeConstraints { make in
                make.bottom.equalTo(playerView.snp.bottom)
                make.left.equalTo(playerView.snp.left)
                make.right.equalTo(playerView.snp.right)
            }
            
            let bufferView = UIActivityIndicatorView(style: .whiteLarge)
            playerView.addSubview(bufferView)
            bufferView.snp.makeConstraints { $0.center.equalTo(playerView.snp.center) }
            playerView.bufferingView = bufferView
            
            self.playerView = playerView

        }
    }
    
    private func setupButton() {
        addSubview(button)
        let inset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : .inset16
        button.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(inset)
            $0.bottom.equalToSuperview().inset(CGFloat.inset8)
        }
    }
    
    private func setupImageView() {
        if imageView == nil {
            let imageView = UIImageView(frame: .zero)
            imageView.contentMode = .scaleAspectFit
            insertSubview(imageView, at: 0)
            self.imageView = imageView
        }
    }
    
    private func resizeImageView() {
        if let image = imageView?.image {
            let rect = AVMakeRect(aspectRatio: image.size, insideRect: bounds)
            //Then figure out offset to center vertically or horizontally
            let x = (bounds.width - rect.width) / 2
            let y = (bounds.height - rect.height) / 2
            
            imageView?.frame = CGRect(x: x, y: y, width: rect.width, height: rect.height)
        }
    }
    
    // MARK: - Configuration
    
    public func configure(urlPath: String?, image: UIImage?) {
        if let urlPath = urlPath,
            let url = URL(string: "\(GlobalUtils.base2chPath)\(urlPath)") {
            self.url = url
            if let image = image, !image.isNFFW {
                if let delegate = delegate, !delegate.isRotating {
                    isNSFW = false
                    setupPlayerView()
                    let item = VersaPlayerItem(url: url)
                    playerView?.autoplay = false
                    playerView?.set(item: item)
                    playerItemView = item
                }
            } else {
                isNSFW = true
                snapshotCropNeeded = false
                setupImageView()
                imageView?.image = image
                resizeImageView()
                button.isHidden = false
            }
        }
    }
    
    // MARK: - VideoContainer
    
    public func pause() {
        if let playerView = playerView, playerView.isPlaying {
            playerView.pause()
        }
    }
    
    public func play() {
        if let playerView = playerView, !playerView.isPlaying {
            playerView.play()
        }
    }
    
    public func snapshot(pauseVideo: Bool) -> UIImage? {
        if !isNSFW {
            if pauseVideo {
                pause()
            }
            
            do {
                return try playerItemView?.snapshot()
            } catch let error {
                print("MP4 SNAPSHOT ERROR = \(error)")
                return nil
            }
        } else {
            return imageView?.image
        }
    }
    
    public func controlsViewFrame() -> CGRect {
        if let playerView = playerView, let controls = playerView.controls, !controls.isHidden {
            return controls.frame
        } else {
            return .zero
        }
    }
}

extension DTMP4CollectionViewCell: VersaPlayerPlaybackDelegate {
    
    public func controlsWillHide(sender: Any?) {
        delegate?.handleVideoTapGesture(hideControls: true)
    }
    
    public func controlsWillShow(sender: Any?) {
        delegate?.handleVideoTapGesture(hideControls: false)
    }
}
