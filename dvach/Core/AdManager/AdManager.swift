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
    func showInterstitialAd()
}

final class AdManager: NSObject, IAdManager {
    
    // Dependencies
    weak var delegate: AdManagerDelegate?
    private let numberOfAds: Int
    private var downloadedAds = 0
    private weak var viewController: UIViewController?
    
    // Properties
    private lazy var adQueue = APDNativeAdQueue()
    
    // MARK: - Initialization
    
    init(numberOfNativeAds: Int, viewController: UIViewController?) {
        self.numberOfAds = numberOfNativeAds
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
    
    private func createAdViews(_ nativeAd: APDNativeAd) {
        guard let vc = viewController else { return }
        guard let view = nativeAd.getViewFor(vc) else { return }
        delegate?.adManagerDidCreateNativeAdView(view)
    }
}

// MARK: - APDNativeAdQueueDelegate

extension AdManager: APDNativeAdQueueDelegate {
    func adQueueAdIsAvailable(_ adQueue: APDNativeAdQueue, ofCount count: UInt) {
        // Как мы можем прочитать из жокументации Appodeal, они отдают рекламу на ГЛАВНОМ потоке. 5 баллов господам. Кроме того, из-за их офигенной системы загрузки рекламы, вместо 1 раза она грузится 2 (иногда 3). Ах, да, они все планируют исправить в следующей версии! Честно-честно
        if downloadedAds >= numberOfAds {
            return
        } else {
            downloadedAds += 1
            if let ad = adQueue.getNativeAds(ofCount: 1).first {
                createAdViews(ad)
            }
        }
    }
}
