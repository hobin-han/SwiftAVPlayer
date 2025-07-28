//
//  PlayerView.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/2/25.
//

import UIKit
import AVFoundation
import Combine

class PlayerView: UIView {
    
    lazy var playerTimeObserver = {
        PlayerTimeObserver(player)
    }()
    
    lazy var playerStatusObserver = {
        PlayerStatusObserver(player)
    }()
    
    lazy var itemStatusObserver = {
        PlayerItemStatusObserver()
    }()
    
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
    
    var player: AVPlayer {
        playerLayer.player!
    }
    
    var playerItem: AVPlayerItem? {
        get {
            player.currentItem
        }
        set {
            if playerItem != nil {
                playerTimeObserver.removeObserver()
            }
            
            player.replaceCurrentItem(with: newValue)
            itemStatusObserver.playerItem = newValue
            
            if newValue != nil {
                playerTimeObserver.addObserver(interval: CMTime(seconds: 1, preferredTimescale: 2))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        playerLayer.player = AVPlayer()
    }
    
    func bind(_ urlString: String) {
        playerItem = URL(string: urlString).map { AVPlayerItem(url: $0) }
    }
}
