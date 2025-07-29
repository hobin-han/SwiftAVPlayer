//
//  PlayerItemFailToPlayToEndObserver.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/10/25.
//

import AVFoundation

class PlayerItemFailToPlayToEndObserver: NSObject {
    
    var callback: ((Error?) -> Void)?
    
    weak var playerItem: AVPlayerItem? {
        willSet {
            NotificationCenter.default.removeObserver(self, name: AVPlayerItem.failedToPlayToEndTimeNotification, object: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(handleDidFailToPlayToEnd), name: AVPlayerItem.failedToPlayToEndTimeNotification, object: newValue)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AVPlayerItem.failedToPlayToEndTimeNotification, object: playerItem)
    }
    
    @objc private func handleDidFailToPlayToEnd(_ notification: Notification) {
        let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error
        callback?(error)
    }
}
