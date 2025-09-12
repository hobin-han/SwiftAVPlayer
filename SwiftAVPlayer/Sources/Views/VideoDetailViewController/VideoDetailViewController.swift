//
//  VideoDetailViewController.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 8/12/25.
//

import UIKit
import AVKit
import PlayerViewKit
import SnapKit
import Combine

final class VideoDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let playerContainerVew = UIView()
    private let playerView = PlayerView()
    private let indicatorView = UIActivityIndicatorView()
    private let interactionView = UIView()
    private let controlView = VideoPlaybackControlView()
    private let progressView = InteractableProgressView()
    
    private lazy var pipController: AVPictureInPictureController? = {
        guard AVPictureInPictureController.isPictureInPictureSupported() else { return nil }
        let pip = AVPictureInPictureController(playerLayer: playerView.playerLayer)
        pip?.delegate = self
        return pip
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var isProgressDragging: Bool = false
    
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
        setupScrollView()
        setupPlayerContainerView()
        setupPipButton()
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
        // playerContainerVew
        playerContainerVew.backgroundColor = .black
        stackView.addArrangedSubview(playerContainerVew)
        playerContainerVew.snp.makeConstraints {
            $0.height.equalTo(playerContainerVew.snp.width).multipliedBy(9.0 / 16.0)
        }
        
        // playerView
        playerView.isHidden = true
        playerContainerVew.addSubview(playerView)
        playerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // indicatorView
        indicatorView.color = .white
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        playerContainerVew.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // interactionView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        interactionView.addGestureRecognizer(tapGesture)
        playerContainerVew.addSubview(interactionView)
        interactionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // controlView
        controlView.delegate = self
        controlView.isHidden = true
        interactionView.addSubview(controlView)
        controlView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // progressView
        progressView.delegate = self
        interactionView.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    private func setupPipButton() {
        let button = UIButton(type: .system)
        button.setTitle("pip", for: .normal)
        button.addTarget(self, action: #selector(pipButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        button.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    private func observe() {
        playerView.playerItemStatusObserver.callback = { [weak self] status in
            guard let strongSelf = self else { return }
            switch status {
            case .readyToPlay:
                strongSelf.playerView.player.play()
                strongSelf.playerView.isHidden = false
            case .failed:
                AVAudioSession.sharedInstance().deactivate()
                strongSelf.playerView.backgroundColor = .systemRed
            default: break
            }
        }
        
        playerView.playerTimeObserver.callback = { [weak self] seconds in
            guard let strongSelf = self,
                  !strongSelf.isProgressDragging,
                  let duration = strongSelf.playerView.playerItem?.duration.seconds, duration > 0 else { return }
            let progressRate = CGFloat(seconds / duration)
            strongSelf.progressView.rate = progressRate
        }
        
        playerView.playerItemFailToPlayToEndObserver.callback = { error in
            AVAudioSession.sharedInstance().deactivate()
            print("playerItemFailToPlayToEndObserver", error.localizedDescription)
        }
        
        playerView.player
            .publisher(for: \.timeControlStatus)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let strongSelf = self else { return }
                switch status {
                case .paused:
                    AVAudioSession.sharedInstance().deactivate()
                    strongSelf.controlView.isPlaying = false
                case .playing:
                    AVAudioSession.sharedInstance().activate()
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
    
    @objc private func pipButtonTapped(_ button: UIButton) {
        guard let isActive = pipController?.isPictureInPictureActive else { return }
        if isActive {
            pipController?.stopPictureInPicture()
        } else {
            pipController?.startPictureInPicture()
        }
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
    
    func videoPlaybackControlDidTapSkipButton(_ control: VideoPlaybackControlView, toSeconds: Double) {
        guard let duration = playerView.playerItem?.duration, duration > .zero,
              let currentTime = playerView.playerItem?.currentTime() else { return }
        let addTime = CMTime(seconds: toSeconds, preferredTimescale: 1)
        playerView.player.seek(to: currentTime + addTime)
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

extension VideoDetailViewController: InteractableProgressViewDelegate {
    
    func interactableProgressView(_ progressView: InteractableProgressView, isInteracting: Bool) {
        isProgressDragging = isInteracting
        if isInteracting {
            playerView.player.pause()
        } else {
            playerView.player.play()
        }
    }
    
    func interactableProgressView(_ progressView: InteractableProgressView, didChangeProgressTo value: Double) {
        guard let duration = playerView.playerItem?.duration else { return }
        let toSeconds = duration.seconds * (value / progressView.bounds.width)
        let toTime = CMTime(seconds: toSeconds, preferredTimescale: CMTimeScale(progressView.bounds.width))
        playerView.player.seek(to: toTime)
    }
}

extension VideoDetailViewController: AVPictureInPictureControllerDelegate {
    
    nonisolated func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        DispatchQueue.main.async {
            self.interactionView.isHidden = true
        }
    }
    
    nonisolated func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        DispatchQueue.main.async {
            self.interactionView.isHidden = false
        }
    }
}
