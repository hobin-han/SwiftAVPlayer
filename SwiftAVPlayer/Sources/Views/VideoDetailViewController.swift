//
//  VideoDetailViewController.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/28/25.
//

import UIKit

class VideoDetailViewController: UIViewController {
    
    var urlString: String? {
        didSet {
            if let playerView {
                if let urlString {
                    playerView.bind(urlString)
                } else {
                    playerView.playerItem = nil
                }
            }
        }
    }
    
    private var playerView: PlayerView!
    private var progressView: ProgressView!
    private var playbackController: PlaybackController!
    
    private lazy var failedLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true // TODO: refactor
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.text = "load failed"
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalTo(playerView)
        }
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupView()
        observe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.player.pause()
    }
    
    private func setupView() {
        let playerView = PlayerView()
        if let urlString {
            playerView.bind(urlString)
        }
        playerView.backgroundColor = .black
        playerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
        view.addSubview(playerView)
        playerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(playerView.snp.width).multipliedBy(9.0 / 16.0)
        }
        self.playerView = playerView
        
        let playbackController = PlaybackController()
        playbackController.delegate = self
        playbackController.isHidden = true
        playbackController.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
        view.addSubview(playbackController)
        playbackController.snp.makeConstraints {
            $0.edges.equalTo(playerView)
        }
        self.playbackController = playbackController
        
        let progressView = ProgressView()
        progressView.backgroundColor = .gray.withAlphaComponent(0.3)
        view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(playerView)
            $0.height.equalTo(4)
        }
        self.progressView = progressView
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        switch gesture.view {
        case playerView:
            playbackController.isHidden = false
        case playbackController:
            playbackController.isHidden = true
        default: break
        }
    }
    
    private func observe() {
        playerView.itemStatusObserver.callback = { [weak self] status in
            guard let strongSelf = self else { return }
            switch status {
            case .readyToPlay:
                strongSelf.playerView.player.play()
            case .failed:
                strongSelf.failedLabel.isHidden = false
            default: break
            }
        }
        
        playerView.playerTimeObserver.callback = { [weak self] seconds in
            guard let strongSelf = self,
                  let duration = strongSelf.playerView.playerItem?.duration.seconds, duration > 0 else { return }
            let progressRate = CGFloat(seconds / duration)
            strongSelf.progressView.rate = progressRate
        }
        
        playerView.playerStatusObserver.callback = { [weak self] status in
            switch status {
            case .paused:
                self?.playbackController.set(isPlaying: false)
            case .playing:
                self?.playbackController.set(isPlaying: true)
            case .waitingToPlayAtSpecifiedRate: ()
            default: break
            }
        }
    }
}

extension VideoDetailViewController: PlaybackControllerDelegate {
    
    func playbackControllerPlay() {
        playbackController.isHidden = true
        playerView.player.play()
    }
    
    func playbackControllerPause() {
        playbackController.isHidden = true
        playerView.player.pause()
    }
}
