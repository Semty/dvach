//
//  GlobalUtils.swift
//  Receipt
//
//  Created by Kirill Solovyov on 22.03.2018.
//  Copyright © 2018 Kirill Solovyov. All rights reserved.
//

import Foundation
import AVKit

public enum GlobalUtils {
    public static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    static var base2chPath: String {
        return "https://2ch.hk"
    }
    
    static var base2chPathWithoutScheme: String {
        return "2ch.hk"
    }
    
    public static func setAudioInSilentModeOn() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,
                                                            mode: .default,
                                                            options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
}
