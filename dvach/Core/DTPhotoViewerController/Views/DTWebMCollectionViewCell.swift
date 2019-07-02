//
//  DTVideoCollectionViewCell.swift
//  dvach
//
//  Created by Ruslan Timchenko on 29/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import OGVKit

public protocol VideoContainer {
    func pause()
    func updateLayout()
    func snapshot(pauseVideo: Bool) -> UIImage
}

open class DTWebMCollectionViewCell: UICollectionViewCell, VideoContainer {
    
    // Player View (WebM Only!)
    public private(set) weak var playerView: OGVPlayerView!
    
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
            playerView.sourceURL = url
            playerView.play()
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
    
    public func updateLayout() {
        playerView.frameView.frame = bounds
    }
    
    public func snapshot(pauseVideo: Bool) -> UIImage {
        if pauseVideo {
            playerView.pause()
        }
        return playerView.frameView.snapshot
    }
}

extension DTWebMCollectionViewCell: OGVPlayerDelegate {
    
}
