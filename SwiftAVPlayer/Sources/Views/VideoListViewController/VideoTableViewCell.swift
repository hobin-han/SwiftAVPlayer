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
    
    private var playerView: PlayerView!
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
        
        cancellableBag.removeAll()
        playerView.playerItem = nil
        
        backgroundColor = nil
        progressView.rate = 0
        progressView.isHidden = true
        isDisplaying = false
    }
    
    private func setupView() {
        let playerView = PlayerView()
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
    
    func apply(_ urlString: String?) {
        guard let urlString else { return }
        observe()
        playerView.bind(urlString)
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
            .subscribe(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] status in
                guard let strongSelf = self else { return }
                switch status {
                case .readyToPlay:
                    strongSelf.backgroundColor = .black
                    strongSelf.progressView.isHidden = false
                    
                    if strongSelf.isDisplaying {
                        strongSelf.playerView.player.play()
                    }
                case .failed:
                    strongSelf.backgroundColor = .systemRed
                default: break
                }
            }
            .store(in: &cancellableBag)
        
        playerView.timeObserver.publisher
            .subscribe(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] seconds in
                guard let strongSelf = self,
                      let duration = strongSelf.playerView.playerItem?.duration.seconds, duration > 0 else { return }
                let progressRate = CGFloat(seconds / duration)
                strongSelf.progressView.rate = progressRate
            }
            .store(in: &cancellableBag)
    }
}
