//
//  PlayerStatusObserver.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/28/25.
//

import AVFoundation
import Combine

final class PlayerStatusObserver: AnyObject, @unchecked Sendable {
    
    var callback: ((AVPlayer.TimeControlStatus) -> Void)?
    
    private weak var player: AVPlayer?
    
    private var cancellable: AnyCancellable?
    
    init(_ player: AVPlayer) {
        self.player = player
        
        cancellable = player.publisher(for: \.timeControlStatus)
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                self?.callback?(status)
            }
    }
}
