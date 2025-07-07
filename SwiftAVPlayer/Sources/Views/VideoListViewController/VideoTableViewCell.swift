//
//  VideoTableViewCell.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/3/25.
//

import UIKit
import SnapKit
import Combine

class VideoTableViewCell: UITableViewCell {
    
    private var playerView: MediaPlayerView!
    private var progressView: ProgressView!
    
    private var cancellableBag: Set<AnyCancellable> = []
    
    var isDisplaying: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = nil
        progressView.isHidden = true
        cancellableBag.removeAll()
        isDisplaying = false
    }
    
    private func setupView() {
        let playerView = MediaPlayerView()
        contentView.addSubview(playerView)
        playerView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        self.playerView = playerView
        
        let progressView = ProgressView()
        progressView.backgroundColor = .gray.withAlphaComponent(0.3)
        progressView.isHidden = true
        contentView.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
        self.progressView = progressView
    }
    
    func bind(urlString: String) {
        observe()
        playerView.url = URL(string: urlString)
    }
    
    func play() {
        guard playerView.statusObserver.value == .readyToPlay else { return }
        playerView.player.play()
    }
    
    func pause() {
        playerView.player.pause()
    }
    
    private func observe() {
        playerView.statusObserver.publisher
            .sink { [weak self] status in
                switch status {
                case .readyToPlay:
                    self?.progressView.isHidden = false
                    
                    if self?.isDisplaying ?? false {
                        self?.playerView.player.play()
                    }
                case .failed:
                    self?.backgroundColor = .systemRed
                default: break
                }
            }
            .store(in: &cancellableBag)
        
        playerView.timeObserver.publisher
            .sink { [weak self] seconds in
                guard let duration = self?.playerView.playerItem?.duration.seconds, duration > 0, let seconds else { return }
                let progressRate = CGFloat(seconds / duration)
                self?.progressView.rate = progressRate
            }
            .store(in: &cancellableBag)
    }
}
