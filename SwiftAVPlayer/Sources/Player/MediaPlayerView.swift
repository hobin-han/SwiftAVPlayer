//
//  MediaPlayerView.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/2/25.
//

import UIKit
import AVFoundation
import Combine

class MediaPlayerView: UIView, MediaPlayer, MediaTimeObservable {
    
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
    
    lazy var player: AVPlayer = {
        let player = AVPlayer()
        playerLayer.player = player
        return player
    }()
    
    var playerItem: AVPlayerItem? {
        get {
            player.currentItem
        }
        set {
            if let playerItem {
                playerItemStatusPublisher.send(nil)
                currentSecondsPublisher.send(nil)
                removeTimeObserver(&playerTimeObserver)
                playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
            }
            
            player.replaceCurrentItem(with: newValue)
            
            if let playerItem = newValue {
                addPeriodicTimeObserver(&playerTimeObserver, forInterval: CMTime(value: 1, timescale: 2))
                playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.initial, .new], context: nil)
            }
        }
    }
    
    var url: URL? {
        get {
            (playerItem?.asset as? AVURLAsset)?.url
        }
        set {
            playerItem = newValue.map { AVPlayerItem(url: $0) }
        }
    }
    
    let playerItemStatusPublisher = CurrentValueSubject<AVPlayerItem.Status?, Never>(nil)
    let currentSecondsPublisher = CurrentValueSubject<Double?, Never>(nil)
    
    private var playerTimeObserver: Any?
    
    deinit {
        playerItem = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case #keyPath(AVPlayerItem.status):
            if let number = change?[.newKey] as? NSNumber, let status = AVPlayerItem.Status(rawValue: number.intValue) {
                playerItemStatusPublisher.send(status)
            }
        default: break
        }
    }
    
    func observingTime(_ time: CMTime) {
        currentSecondsPublisher.send(time.seconds)
    }
}
