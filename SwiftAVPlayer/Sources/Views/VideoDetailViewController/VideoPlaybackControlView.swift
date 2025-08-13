//
//  VideoPlaybackControlView.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 8/12/25.
//

import UIKit

@MainActor protocol VideoPlaybackControlDelegate: AnyObject {
    func videoPlaybackControlDidTapPlayButton(_ control: VideoPlaybackControlView)
    func videoPlaybackControlDidTapPauseButton(_ control: VideoPlaybackControlView)
    func videoPlaybackControlDidTapSettingButton(_ control: VideoPlaybackControlView)
}

final class VideoPlaybackControlView: UIView {
    
    weak var delegate: VideoPlaybackControlDelegate?
    
    var playButton: UIButton!
    var pauseButton: UIButton!
    var settingButton: UIButton!
    
    var isPlaying: Bool = false {
        didSet {
            playButton.isHidden = isPlaying
            pauseButton.isHidden = !isPlaying
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
        backgroundColor = .black.withAlphaComponent(0.3)
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30)
        
        let playButton = UIButton(configuration: buttonConfig)
        playButton.setSystemImage("play.fill")
        playButton.tintColor = .white
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        self.playButton = playButton
        
        let pauseButton = UIButton(configuration: buttonConfig)
        pauseButton.isHidden = true
        pauseButton.setSystemImage("pause.fill")
        pauseButton.tintColor = .white
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        addSubview(pauseButton)
        pauseButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        self.pauseButton = pauseButton
        
        let settingButton = UIButton(configuration: buttonConfig)
        settingButton.setSystemImage("gearshape")
        settingButton.tintColor = .white
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        addSubview(settingButton)
        settingButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
        }
        self.settingButton = settingButton
    }
    
    @objc private func playButtonTapped(_ button: UIButton) {
        delegate?.videoPlaybackControlDidTapPlayButton(self)
    }
    
    @objc private func pauseButtonTapped(_ button: UIButton) {
        delegate?.videoPlaybackControlDidTapPauseButton(self)
    }
    
    @objc private func settingButtonTapped(_ button: UIButton) {
        delegate?.videoPlaybackControlDidTapSettingButton(self)
    }
}
