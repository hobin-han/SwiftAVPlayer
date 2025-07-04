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

/*
// bugs in Swift - enum property will not work with KVO
// https://github.com/swiftlang/swift-corelibs-foundation/issues/3807
class PlayerItemStatusObserver: NSObject {

    @Published var status: AVPlayerItem.Status = .unknown
    
    private let playerItem: AVPlayerItem
    private var observation: NSKeyValueObservation?
    
    init(_ playerItem: AVPlayerItem) {
        self.playerItem = playerItem
        super.init()
        
        observation = playerItem.observe(\.status, options: [.old, .initial, .new]) { [weak self] object, change in
            print("changed from: \(change.oldValue), updated to: \(change.newValue)")
            guard let status = change.newValue else { return }
            self?.status = status
        }
    }
}
*/
