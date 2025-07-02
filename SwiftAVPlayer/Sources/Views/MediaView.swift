//
//  MediaView.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/2/25.
//

import UIKit
import AVFoundation

class MediaView: UIView {
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
            player.replaceCurrentItem(with: newValue)
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
    
    var currentTime: CMTime? {
        playerItem?.currentTime()
    }
}
