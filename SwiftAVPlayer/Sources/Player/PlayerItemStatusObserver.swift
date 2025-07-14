//
//  PlayerItemStatusObserver.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/7/25.
//

import AVFoundation
import Combine

class PlayerItemStatusObserver: NSObject {
    
    var cancellable: AnyCancellable?
    
    var callback: ((AVPlayerItem.Status) -> Void)?
    
    weak var playerItem: AVPlayerItem? {
        didSet {
            cancellable = playerItem?.publisher(for: \.status, options: [.initial, .new])
                .sink(receiveValue: { [weak self] status in
                    self?.callback?(status)
                })
        }
    }
}
