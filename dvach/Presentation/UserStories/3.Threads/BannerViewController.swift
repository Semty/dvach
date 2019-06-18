//
//  BannerViewController.swift
//  dvach
//
//  Created by Ruslan Timchenko on 18/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import UIKit

class BannerViewController: UIViewController {

    var shouldHideHomeIndicator = false
    
    // UI
    private lazy var bannerView: BannerView = {
        let bannerView = BannerView.fromNib()
        let model = BannerView.Model(image: UIImage(named: "warning") ?? UIImage(),
                                     imageColor: .n4Red,
                                     backgroundColor: .white,
                                     title: "NSFW",
                                     description: GlobalUtils.boardWarning)
        bannerView.configure(with: model)
        return bannerView
    }()

    
    // Overridden Variables
    override var prefersHomeIndicatorAutoHidden: Bool {
        return shouldHideHomeIndicator
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .bottom
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
//        view.addSubview(bannerView)
//        bannerView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func loadView() {
        view = bannerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldHideHomeIndicator = true
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
}
