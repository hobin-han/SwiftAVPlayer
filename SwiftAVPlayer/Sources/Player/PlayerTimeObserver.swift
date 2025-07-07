//
//  PlayerTimeObserver.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/7/25.
//

import Combine
import AVFoundation

class PlayerTimeObserver: AnyObject {
    
    let publisher = CurrentValueSubject<Double?, Never>(nil)
    
    var value: Double? {
        publisher.value
    }
    
    private weak var player: AVPlayer?
    
    private var playerTimeObserver: Any?
    
    init(_ player: AVPlayer) {
        self.player = player
    }
    
    deinit {
        removeObserver()
        publisher.send(completion: .finished)
    }
    
    func addObserver(interval: CMTime) {
        guard playerTimeObserver == nil else { return }
        
        playerTimeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { [weak self] in
            self?.publisher.send($0.seconds)
        })
    }
    
    func removeObserver() {
        guard let observer = playerTimeObserver else { return }
        
        player?.removeTimeObserver(observer)
        playerTimeObserver = nil
    }
}
