//
//  VideoDetailViewController.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 8/12/25.
//

import UIKit
import AVFoundation
import PlayerViewKit
import SnapKit
import Combine

final class VideoDetailViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    private lazy var playerView = PlayerView()
    
    private var controlView: VideoPlaybackControlView!
    
    private var cancellables: Set<AnyCancellable> = []
    
    var videoUrl: String? {
        didSet {
            playerView.playerItem = videoUrl
                .flatMap { URL(string: $0) }
                .flatMap { AVPlayerItem(url: $0) }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        observe()
    }
    
    private func setupView() {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.scrollView = scrollView
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        self.stackView = stackView
        
        stackView.addArrangedSubview(playerView)
        playerView.snp.makeConstraints {
            $0.height.equalTo(playerView.snp.width).multipliedBy(9.0 / 16.0)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        playerView.addGestureRecognizer(tapGesture)
        
        let controlView = VideoPlaybackControlView()
        controlView.delegate = self
        controlView.isHidden = true
        playerView.addSubview(controlView)
        controlView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.controlView = controlView
    }
    
    private func observe() {
        playerView.playerItemStatusObserver.callback = { [weak self] status in
            guard let strongSelf = self else { return }
            switch status {
            case .readyToPlay:
                strongSelf.playerView.backgroundColor = .black
                strongSelf.playerView.player.play()
            case .failed:
                strongSelf.playerView.backgroundColor = .systemRed
            default: break
            }
        }
        
//        playerView.playerTimeObserver.callback = { [weak self] seconds in
//            guard let strongSelf = self,
//                  let duration = strongSelf.playerView.playerItem?.duration.seconds, duration > 0 else { return }
//            let progressRate = CGFloat(seconds / duration)
//            strongSelf.progressView.rate = progressRate
//        }
        
        playerView.playerItemFailToPlayToEndObserver.callback = { error in
            print("playerItemFailToPlayToEndObserver", error.localizedDescription)
        }
        
        playerView.player
            .publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let strongSelf = self else { return }
                switch status {
                case .paused:
                    strongSelf.controlView.isPlaying = false
//                    strongSelf.indicatorView.stopAnimating()
                case .playing:
                    strongSelf.controlView.isPlaying = true
//                    strongSelf.indicatorView.stopAnimating()
                case .waitingToPlayAtSpecifiedRate: ()
//                    strongSelf.indicatorView.startAnimating()
                @unknown default: break
                }
            }.store(in: &cancellables)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        controlView.isHidden.toggle()
    }
}

extension VideoDetailViewController: UIScrollViewDelegate {
    
}

extension VideoDetailViewController: VideoPlaybackControlDelegate {
    
    func videoPlaybackControlDidTapPlayButton(_ control: VideoPlaybackControlView) {
        playerView.player.play()
    }
    
    func videoPlaybackControlDidTapPauseButton(_ control: VideoPlaybackControlView) {
        playerView.player.pause()
    }
    
    func videoPlaybackControlDidTapSettingButton(_ control: VideoPlaybackControlView) {
        let alert = UIAlertController(title: "speed", message: "choose speed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        [Float](arrayLiteral: 0.5, 1, 2).forEach { speed in
            let action = UIAlertAction(title: "\(speed)x", style: .default) { [weak self] _ in
                self?.playerView.player.rate = speed
            }
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
}
