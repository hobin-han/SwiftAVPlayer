//
//  PlayerItemStatusObserver.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/7/25.
//

import AVFoundation

class PlayerItemStatusObserver: NSObject {
    
    var callback: ((AVPlayerItem.Status) -> Void)?
    
    weak var playerItem: AVPlayerItem? {
        willSet {
            playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
            newValue?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.initial, .new], context: nil)
        }
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    
    /*
     [Warning]
     "Block Based KVO Violation: Prefer the new block based KVO API with keypaths when using Swift 3.2 or later (block_based_kvo)"
     
     bugs in Swift - enum property will not work with KVO
     https://github.com/swiftlang/swift-corelibs-foundat
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case #keyPath(AVPlayerItem.status):
            if let number = change?[.newKey] as? NSNumber, let status = AVPlayerItem.Status(rawValue: number.intValue) {
                callback?(status)
            }
        default: break
        }
    }
}
