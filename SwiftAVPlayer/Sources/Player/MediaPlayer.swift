//
//  MediaPlayer.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/3/25.
//

import AVFoundation

protocol MediaPlayer: AnyObject {
    var playerLayer: AVPlayerLayer { get }
    var player: AVPlayer { get set }
}

protocol MediaTimeObservable {
    func observingTime(_ time: CMTime)
}

extension MediaTimeObservable where Self: MediaPlayer {
    func addPeriodicTimeObserver(_ observer: inout Any?, forInterval interval: CMTime) {
        observer = player.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { [weak self] in
            self?.observingTime($0)
        })
    }
    
    func removeTimeObserver(_ observer: inout Any?) {
        if let observer {
            player.removeTimeObserver(observer)
        }
        observer = nil
    }
}
