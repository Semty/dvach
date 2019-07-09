//
//  DTVideoCollectionViewCell.swift
//  dvach
//
//  Created by Ruslan Timchenko on 29/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import OGVKit

@objc public protocol VideoContainer {
    var snapshotCropNeeded: Bool { get }
    func controlsViewFrame() -> CGRect
    func pause()
    func play()
    func snapshot(pauseVideo: Bool) -> UIImage?
    func configure(urlPath: String?)
    @objc optional func updateLayout()
}

public protocol VideoContainerDelegate: class {
    var isRotating: Bool { get }
    func handleVideoTapGesture(hideControls hide: Bool)
}

open class DTWebMCollectionViewCell: UICollectionViewCell, VideoContainer {
    
    public var snapshotCropNeeded = true
    
    // Player View (WebM Only!)
    public private(set) weak var playerView: OGVPlayerView!
    
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
        let playerView = OGVPlayerView(frame: bounds)
        playerView.delegate = self
        addSubview(playerView)
        playerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.playerView = playerView
    }
    
    // MARK: - Configuration
    
    public func configure(urlPath: String?) {
        
        if let urlPath = urlPath, let url = URL(string: "\(GlobalUtils.base2chPath)\(urlPath)") {
            if let delegate = delegate, !delegate.isRotating {
                playerView.sourceURL = url
            }
        } else {
            print("DTWebMCollectionViewCell, URL PATH IS INCORRECT")
        }
    }
    
    // MARK: - VideoContainer
    
    public func pause() {
        if !playerView.paused {
            playerView.pause()
        }
    }
    
    public func play() {
        if playerView.paused {
            playerView.play()
        }
    }
    
    public func updateLayout() {
        playerView.frameView.frame = bounds
    }
    
    public func snapshot(pauseVideo: Bool) -> UIImage? {
        if pauseVideo {
            pause()
        }
        return playerView.frameView.snapshot
    }
    
    public func controlsViewFrame() -> CGRect {
        if !playerView.controlBar.isHidden {
            return playerView.controlBar.frame
        } else {
            return .zero
        }
    }
}

extension DTWebMCollectionViewCell: OGVPlayerDelegate {
    
    public func ogvPlayerControlsWillHide(_ sender: OGVPlayerView!) {
        delegate?.handleVideoTapGesture(hideControls: true)
    }
    
    public func ogvPlayerControlsWillShow(_ sender: OGVPlayerView!) {
        delegate?.handleVideoTapGesture(hideControls: false)
    }
}
