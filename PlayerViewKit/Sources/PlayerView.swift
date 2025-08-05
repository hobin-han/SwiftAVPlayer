//
//  PlayerView.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/2/25.
//

import UIKit
import AVFoundation
import Combine

public class PlayerView: UIView {
    
    public lazy var timeObserver = {
        PlayerTimeObserver(player)
    }()
    
    public let statusObserver = PlayerItemStatusObserver()
    
    public override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    public var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
    
    public var player: AVPlayer {
        guard let player = playerLayer.player else {
            fatalError("AVPlayer instance not found. This indicates an initialization issue.")
        }
        return player
    }
    
    public var playerItem: AVPlayerItem? {
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
    
    @discardableResult
    public func bind(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            playerItem = nil
            return false
        }
        playerItem = AVPlayerItem(url: url)
        return true
    }
}
