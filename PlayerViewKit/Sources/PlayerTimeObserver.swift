//
//  PlayerTimeObserver.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/7/25.
//

import AVFoundation

final class PlayerTimeObserver: AnyObject, @unchecked Sendable {
    
    var callback: ((Double) -> Void)?
    
    private weak var player: AVPlayer?
    
    private var playerTimeObserver: Any?
    
    init(_ player: AVPlayer) {
        self.player = player
    }
    
    deinit {
        removeObserver()
    }
    
    func addObserver(interval: CMTime) {
        guard playerTimeObserver == nil else { return }
        
        // If queue is nil, it guarantees Main Thread in closure
        playerTimeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { [weak self] in
            self?.callback?($0.seconds)
        })
    }
    
    func removeObserver() {
        guard let observer = playerTimeObserver else { return }
        
        player?.removeTimeObserver(observer)
        playerTimeObserver = nil
    }
}
