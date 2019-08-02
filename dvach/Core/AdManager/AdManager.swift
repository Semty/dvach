//
//  AdManager.swift
//  dvach
//
//  Created by Kirill Solovyov on 23/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Appodeal

public typealias AdView = (UIView & APDNativeAdView)

protocol AdManagerDelegate: AnyObject {
    func adManagerDidCreateNativeAdView(_ view: AdView)
}

protocol IAdManager: AnyObject {
    var delegate: AdManagerDelegate? { get set }
    func loadNativeAd()
}

final class AdManager: NSObject, IAdManager {
    
    weak var adDownloader = AdDownloader.shared
    
    // Dependencies
    weak var delegate: AdManagerDelegate?
    private let numberOfAds: Int
    private weak var viewController: UIViewController?
    
    // Ad Download Timer
    private var timer: Timer?
    
    // MARK: - Initialization
    
    init(numberOfNativeAds: Int, viewController: UIViewController?) {
        self.numberOfAds = numberOfNativeAds
        self.viewController = viewController
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - IAdManager
    
    func loadNativeAd() {
        if let ads = adDownloader?.loadNativeAd(), !ads.isEmpty {
            timer?.invalidate()
            timer = nil
            DispatchQueue.main.async { [weak self] in
                self?.createAdViews(ads)
            }
        } else {
            if timer == nil {
                DispatchQueue.main.async { [weak self] in
                    self?.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { [weak self] _ in
                        if self?.timer != nil {
                            self?.loadNativeAd()
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func createAdViews(_ ads: [APDNativeAd]) {
        guard let vc = viewController else { return }
        for nativeAd in ads {
            guard let view = nativeAd.getViewFor(vc) else { return }
            delegate?.adManagerDidCreateNativeAdView(view)
        }
    }
}
