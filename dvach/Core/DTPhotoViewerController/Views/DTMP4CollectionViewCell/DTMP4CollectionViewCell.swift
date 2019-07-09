//
//  DTMP4CollectionViewCell.swift
//  dvach
//
//  Created by Ruslan Timchenko on 07/07/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import VersaPlayer

open class DTMP4CollectionViewCell: UICollectionViewCell, VideoContainer {

    public var snapshotCropNeeded = false
    
    // Player View (WebM Only!)
    public private(set) weak var playerView: VersaPlayerView!
    
    private var playerItemView: VersaPlayerItem?
    private lazy var playerControlsView = VersaPlayerControls.fromNib(.main)
    
    // Delegate
    public weak var delegate: VideoContainerDelegate?
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
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
    
    // MARK: - Configuration
    
    public func configure(urlPath: String?) {
        
        if let urlPath = urlPath, let url = URL(string: "\(GlobalUtils.base2chPath)\(urlPath)") {
            if let delegate = delegate, !delegate.isRotating {
                let item = VersaPlayerItem(url: url)
                playerView.autoplay = false
                playerView.set(item: item)
                playerItemView = item
            }
        } else {
            print("DTWebMCollectionViewCell, URL PATH IS INCORRECT")
        }
    }
    
    // MARK: - VideoContainer
    
    public func pause() {
        if playerView.isPlaying {
            playerView.pause()
        }
    }
    
    public func play() {
        if !playerView.isPlaying {
            playerView.play()
        }
    }
    
    public func snapshot(pauseVideo: Bool) -> UIImage? {
        if pauseVideo {
            pause()
        }
        
        do {
            return try playerItemView?.snapshot()
        } catch let error {
            print("MP4 SNAPSHOT ERROR = \(error)")
            return nil
        }
    }
    
    public func controlsViewFrame() -> CGRect {
        if let controls = playerView.controls, !controls.isHidden {
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
