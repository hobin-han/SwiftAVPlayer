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
    
    let playButton = UIButton()
    let pauseButton = UIButton()
    let settingButton = UIButton()
    
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
        
        let playbackButtonConfig = UIButton.Configuration.filled().update {
            $0.cornerStyle = .capsule
            $0.baseForegroundColor = .white
            $0.background.backgroundColor = .black.withAlphaComponent(0.3)
            $0.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
            $0.contentInsets = .all(10)
        }
        
        playButton.setSystemImage("play.fill")
        playButton.configuration = playbackButtonConfig
        playButton.addAction(UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.videoPlaybackControlDidTapPlayButton(strongSelf)
        }, for: .touchUpInside)
        addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        pauseButton.setSystemImage("pause.fill")
        pauseButton.configuration = playbackButtonConfig
        pauseButton.isHidden = true
        pauseButton.addAction(UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.videoPlaybackControlDidTapPauseButton(strongSelf)
        }, for: .touchUpInside)
        addSubview(pauseButton)
        pauseButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        let settingButtonConfig = UIButton.Configuration.plain().update {
            $0.baseForegroundColor = .white
            $0.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
            $0.contentInsets = .all(5)
        }
        
        settingButton.setSystemImage("gearshape")
        settingButton.configuration = settingButtonConfig
        settingButton.addAction(UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.videoPlaybackControlDidTapSettingButton(strongSelf)
        }, for: .touchUpInside)
        addSubview(settingButton)
        settingButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
        }
    }
}
