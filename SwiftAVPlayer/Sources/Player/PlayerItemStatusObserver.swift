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
            cancellable?.cancel()
            cancellable = newValue?.publisher(for: \.status, options: [.initial, .new])
                .sink(receiveValue: { [weak self] status in
                    self?.callback?(status)
                })
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
