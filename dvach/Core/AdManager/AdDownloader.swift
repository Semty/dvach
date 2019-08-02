//
//  AdDownloader.swift
//  dvach
//
//  Created by Ruslan Timchenko on 01/08/2019.
//  Copyright © 2019 Kirill Solovyov. All rights reserved.
//

import Foundation
import Appodeal

protocol IAdDownloader: AnyObject {
    func loadNativeAd() -> [APDNativeAd]
}

final class AdDownloader: NSObject, IAdDownloader {
    
    // Singletone
    public static var shared = AdDownloader()
    
    // Dependencies
    private var numberOfAds = 1
    private weak var viewController: UIViewController?
    
    // Flags
    private var isDownloadingAds = false
    
    // Properties
    private lazy var adQueue = APDNativeAdQueue()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        adQueue.settings.adViewClass = ContextAddView.self
        adQueue.settings.autocacheMask = [.icon, .media]
        adQueue.settings.type = .noVideo
        adQueue.delegate = self
    }
    
    // MARK: - AdDownloader
    
    func loadNativeAd() -> [APDNativeAd] {
        if !isDownloadingAds {
            isDownloadingAds = true
            if adQueue.currentAdCount >= numberOfAds {
                return adQueue.getNativeAds(ofCount: numberOfAds)
            } else {
                print("\n\nSTART TO DOWNLOAD ADS\n\n")
                adQueue.loadAd()
                return []
            }
        } else {
            return []
        }
    }
}

// MARK: - APDNativeAdQueueDelegate

extension AdDownloader: APDNativeAdQueueDelegate {
    func adQueueAdIsAvailable(_ adQueue: APDNativeAdQueue, ofCount count: UInt) {
        // Как мы можем прочитать из жокументации Appodeal, они отдают рекламу на ГЛАВНОМ потоке. 5 баллов господам. Кроме того, из-за их офигенной системы загрузки рекламы, вместо 1 раза она грузится 2 (иногда 3). Ах, да, они все планируют исправить в следующей версии! Честно-честно
        // Update: после долгой переписки они, вроде как, серверно ограничат нас на загрузку 1 рекламы за раз. Пока данное решение видится оптимальным
        // One more update: серверное ограничение пока не сильно помогло, we're waiting for
        print("\n\nAD DOWNLOADER: adQueueAdIsAvailable, WE HAVE \(adQueue.currentAdCount) ADS HERE\n\n")
        if adQueue.currentAdCount >= numberOfAds {
            isDownloadingAds = false
            return
        }
    }
}
