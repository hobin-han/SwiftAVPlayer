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
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let playerContainerVew = UIView()
    private let playerView = PlayerView()
    private let indicatorView = UIActivityIndicatorView()
    private let controlView = VideoPlaybackControlView()
    private let progressView = ProgressView()
    
    private var cancellables: Set<AnyCancellable> = []
    
    var videoUrl: String? {
        didSet {
            playerView.playerItem = videoUrl
                .flatMap { URL(string: $0) }
                .flatMap { AVPlayerItem(url: $0) }
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        observe()
    }
    
    private func setupView() {
        setupScrollView()
        setupPlayerContainerView()
        setupPlayerView()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupPlayerContainerView() {
        playerContainerVew.backgroundColor = .black
        stackView.addArrangedSubview(playerContainerVew)
        playerContainerVew.snp.makeConstraints {
            $0.height.equalTo(playerContainerVew.snp.width).multipliedBy(9.0 / 16.0)
        }
        
        playerContainerVew.addSubview(playerView)
        playerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicatorView.color = .white
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        playerContainerVew.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupPlayerView() {
        controlView.delegate = self
        controlView.isHidden = true
        playerView.addSubview(controlView)
        controlView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        playerView.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        playerView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        playerView.addGestureRecognizer(tapGesture)
    }
    
    private func observe() {
        playerView.playerItemStatusObserver.callback = { [weak self] status in
            guard let strongSelf = self else { return }
            switch status {
            case .readyToPlay:
                strongSelf.playerView.player.play()
                strongSelf.playerView.isHidden = false
            case .failed:
                strongSelf.playerView.backgroundColor = .systemRed
            default: break
            }
        }
        
        playerView.playerTimeObserver.callback = { [weak self] seconds in
            guard let strongSelf = self,
                  let duration = strongSelf.playerView.playerItem?.duration.seconds, duration > 0 else { return }
            let progressRate = CGFloat(seconds / duration)
            strongSelf.progressView.rate = progressRate
        }
        
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
                case .playing:
                    strongSelf.indicatorView.stopAnimating()
                    strongSelf.controlView.isPlaying = true
                case .waitingToPlayAtSpecifiedRate:
                    strongSelf.indicatorView.startAnimating()
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
    
    func videoPlaybackControlDidTapPlaybackButton(_ control: VideoPlaybackControlView, willPlay: Bool) {
        if willPlay {
            playerView.player.play()
        } else {
            playerView.player.pause()
        }
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
