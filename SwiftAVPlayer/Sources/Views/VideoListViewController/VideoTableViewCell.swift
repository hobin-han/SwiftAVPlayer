//
//  VideoTableViewCell.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/3/25.
//

import UIKit
import SnapKit

class VideoTableViewCell: UITableViewCell {
    
    private var playerView: MediaPlayerView!
    private var progressView: ProgressView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let playerView = MediaPlayerView()
        playerView.timeObserver = { [weak self, weak playerView] seconds in
            guard let duration = playerView?.duration, duration > 0 else { return }
            let progressRate = CGFloat(seconds / duration)
            self?.progressView.rate = progressRate
        }
        contentView.addSubview(playerView)
        playerView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        self.playerView = playerView
        
        let progressView = ProgressView()
        progressView.backgroundColor = .gray.withAlphaComponent(0.3)
        contentView.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
        self.progressView = progressView
    }
    
    func set(_ urlString: String) {
        playerView.url = URL(string: urlString)
    }
    
    func play() {
        playerView.player.play()
    }
    
    func pause() {
        playerView.player.pause()
    }
}
