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
    
    var player: AVPlayer {
        playerLayer.player!
    }
    
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
