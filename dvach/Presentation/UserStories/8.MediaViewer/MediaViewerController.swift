//
//  MediaViewerController.swift
//  dvach
//
//  Created by Ruslan Timchenko on 20/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation

protocol MediaViewer: AnyObject {
    
}

final class MediaViewerController: DTMediaViewerController {
    
    // Dependencies
    private let presenter: IMediaViewerPresenter
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // UI
    private lazy var closeButton = componentsFactory.createCloseButton(.black, .white) { [weak self] in
        self?.configureSecondaryViews(hidden: true, animated: false)
        self?.dismiss(animated: true)
    }
    
    private lazy var horizontalMoreButton = componentsFactory.createHorizontalMoreButton(.white) { [weak self] in
        self?.presenter.didTapMoreButton()
    }
    
    // Overridden UIViewController Variables
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Overridden DTMediaViewController Variables
    override var scaleWhileDragging: Bool {
        return false
    }
    
    // MARK: - Initialization
    
    override init(referencedView: UIImageView?, image: UIImage?) {
        let presenter = MediaViewerPresenter()
        self.presenter = presenter
        super.init(referencedView: referencedView, image: image)
        
        presenter.view = self
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
        configureSecondaryViews(hidden: true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue),
                                  forKey: "orientation")
    }
        
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        closeButton.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(CGFloat.inset2 + view.safeAreaInsets.top)
        }
        horizontalMoreButton.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(CGFloat.inset12 + view.safeAreaInsets.top)
        }
    }
    
    // MARK: - Private Setup
    
    private func setupUI() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(CGFloat.inset2)
            make.leading.equalToSuperview().inset(CGFloat.inset16)
        }
        
        view.addSubview(horizontalMoreButton)
        horizontalMoreButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(CGFloat.inset12)
            make.trailing.equalToSuperview().inset(CGFloat.inset16)
        }
        
        registerClassPhotoViewer(PhotoViewerCollectionViewCell.self)
    }
    
    // MARK: - Hide/Unhide Secondary Views Behaviour
    
    public func configureSecondaryViews(hidden: Bool, animated: Bool) {
        if hidden != closeButton.isHidden {
            let duration: TimeInterval = animated ? 0.2 : 0
            let alpha: CGFloat = hidden ? 0 : 1
            
            // Always unhide view before animation
            closeButton.isHidden = false
            horizontalMoreButton.isHidden = false
            
            UIView.animate(withDuration: duration, animations: { [weak self] in
                self?.closeButton.alpha = alpha
                self?.horizontalMoreButton.alpha = alpha
                }, completion: { [weak self] _ in
                    self?.closeButton.isHidden = hidden
                    self?.horizontalMoreButton.isHidden = hidden
                }
            )
        }
    }
    
    // Hide & Show info layer view
    private func hideUnhideViewsWithZoom() {
        if zoomScale == 1 {
            if closeButton.isHidden == true {
                configureSecondaryViews(hidden: false, animated: true)
            } else {
                configureSecondaryViews(hidden: true, animated: true)
            }
        }
    }
    
    // MARK: - Overridden DTMediaViewerController Methods
    
    override func didReceiveTapGesture() {
        hideUnhideViewsWithZoom()
    }
    
    override func willZoomOnPhoto(at index: Int) {
        configureSecondaryViews(hidden: true, animated: false)
    }
    
    override func didEndZoomingOnPhoto(at index: Int, atScale scale: CGFloat) {
        if scale == 1 {
            configureSecondaryViews(hidden: false, animated: true)
        }
    }
    
    override func didEndPresentingAnimation() {
        configureSecondaryViews(hidden: false, animated: true)
    }
    
    override func willBegin(panGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
        configureSecondaryViews(hidden: true, animated: false)
    }
    
    override func didReceiveDoubleTapGesture() {
        configureSecondaryViews(hidden: true, animated: false)
    }
    
    // MARK: - Rotation Handling

    @objc func canRotate() -> Void {}
}

// MARK: - MediaViewer

extension MediaViewerController: MediaViewer {
    
}
