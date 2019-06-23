//
//  AdManager.swift
//  dvach
//
//  Created by Kirill Solovyov on 23/06/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Appodeal

protocol AdManagerDelegate: AnyObject {
    func adManagerDidCreateNativeAdViews(_ views: [(UIView & APDNativeAdView)])
}

protocol IAdManager: AnyObject {
    var delegate: AdManagerDelegate? { get set }
    func loadNativeAd()
    func showInterstitialAd()
}

final class AdManager: NSObject, IAdManager {
    
    // Dependencies
    weak var delegate: AdManagerDelegate?
    private weak var viewController: UIViewController?
    
    // Properties
    private lazy var adQueue = APDNativeAdQueue()
    private var nativeAds = [APDNativeAd]()
    private lazy var queueLoaded: Bool = {
        createAdViews()
        return true
    }()
    
    // MARK: - Initialization
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    // MARK: - IAdManager
    
    func loadNativeAd() {
        adQueue.settings.adViewClass = ContextAddView.self
        adQueue.settings.autocacheMask = [.icon, .media]
        adQueue.settings.type = .noVideo
        adQueue.delegate = self
        
        adQueue.loadAd()
    }
    
    func showInterstitialAd() {
        guard let vc = viewController else { return }
        if Appodeal.isReadyForShow(with: .interstitial) {
            Appodeal.showAd(.interstitial, rootViewController: vc)
        }
    }
    
    // MARK: - Private
    
    private func createAdViews() {
        guard let vc = viewController else { return }
        let views = nativeAds.compactMap { $0.getViewFor(vc) }
        delegate?.adManagerDidCreateNativeAdViews(views)
    }
}

// MARK: - APDNativeAdQueueDelegate

extension AdManager: APDNativeAdQueueDelegate {
    
    func adQueueAdIsAvailable(_ adQueue: APDNativeAdQueue, ofCount count: UInt) {
        if nativeAds.count > 0 {
            _ = queueLoaded
            return
        } else {
            nativeAds.append(contentsOf: adQueue.getNativeAds(ofCount: 1))
        }
    }
}
