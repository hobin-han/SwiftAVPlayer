//
//  PlayerItemStatusObserver.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/7/25.
//

import AVFoundation
import Combine

class PlayerItemStatusObserver: NSObject {
    
    var callback: ((AVPlayerItem.Status) -> Void)?
    
    private var cancellable: AnyCancellable?
    
    weak var playerItem: AVPlayerItem? {
        willSet {
            removeObserver()
            addObserver(newValue)
        }
    }
    
    deinit {
        removeObserver()
    }
    
    /*
     When I try to use KVO Warning occurs like below.
     "Block Based KVO Violation: Prefer the new block based KVO API with keypaths when using Swift 3.2 or later (block_based_kvo)"
     
     😢 bugs in Swift - enum property will not work with KVO
     https://github.com/swiftlang/swift-corelibs-foundat
     
     So, I used Combine.
     */
    private func addObserver(_ playerItem: AVPlayerItem?) {
        cancellable = playerItem?.publisher(for: \.status, options: [.initial, .new])
            .sink(receiveValue: { [weak self] status in
                self?.callback?(status)
            })
    }
    
    private func removeObserver() {
        cancellable?.cancel()
    }
}
