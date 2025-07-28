//
//  PlaybackController.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/27/25.
//

import UIKit
import SnapKit
import AVFoundation

@MainActor
protocol PlaybackControllerDelegate: AnyObject {
    func playbackControllerPlay()
    func playbackControllerPause()
}

class PlaybackController: UIView {
    
    weak var delegate: PlaybackControllerDelegate?
    
    private var playButton: UIButton!
    private var pauseButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .black.withAlphaComponent(0.5)
        
        let config = UIImage.SymbolConfiguration(pointSize: 44)
        
        let playButton = UIButton(type: .custom)
        playButton.isExclusiveTouch = true
        playButton.addTarget(self, action: #selector(self.playbackTapped(_:)), for: .touchUpInside)
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        playButton.tintColor = .white
        addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        self.playButton = playButton
        
        let pauseButton = UIButton(type: .custom)
        pauseButton.isHidden = true
        pauseButton.isExclusiveTouch = true
        pauseButton.addTarget(self, action: #selector(self.playbackTapped(_:)), for: .touchUpInside)
        pauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: config), for: .normal)
        pauseButton.tintColor = .white
        addSubview(pauseButton)
        pauseButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        self.pauseButton = pauseButton
    }
    
    @objc private func playbackTapped(_ button: UIButton) {
        switch button {
        case playButton:
            delegate?.playbackControllerPlay()
        case pauseButton:
            delegate?.playbackControllerPause()
        default: break
        }
    }
    
    func set(isPlaying: Bool) {
        playButton.isHidden = isPlaying
        pauseButton.isHidden = !isPlaying
    }
}
