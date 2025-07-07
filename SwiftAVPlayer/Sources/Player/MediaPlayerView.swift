//
//  MediaPlayerView.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/2/25.
//

import UIKit
import AVFoundation
import Combine

class MediaPlayerView: UIView {
    
    lazy var timeObserver = {
        PlayerTimeObserver(player)
    }()
    
    let statusObserver = PlayerItemStatusObserver()
    
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
            if playerItem != nil {
                timeObserver.removeObserver()
            }
            
            player.replaceCurrentItem(with: newValue)
            statusObserver.playerItem = newValue
            
            if newValue != nil {
                timeObserver.addObserver(interval: CMTime(seconds: 1, preferredTimescale: 2))
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
}
