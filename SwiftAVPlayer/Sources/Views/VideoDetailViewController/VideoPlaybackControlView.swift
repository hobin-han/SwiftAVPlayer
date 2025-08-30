//
//  VideoPlaybackControlView.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 8/12/25.
//

import UIKit

@MainActor protocol VideoPlaybackControlDelegate: AnyObject {
    func videoPlaybackControlDidTapPlaybackButton(_ control: VideoPlaybackControlView, willPlay: Bool)
    func videoPlaybackControlDidTapSettingButton(_ control: VideoPlaybackControlView)
}

final class VideoPlaybackControlView: UIView {
    
    weak var delegate: VideoPlaybackControlDelegate?
    
    private let playbackButton = PlaybackButton()
    private let settingButton = UIButton()
    
    var isPlaying: Bool = false {
        didSet {
            playbackButton.isPlayShown = !isPlaying
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
        
        playbackButton.configurationUpdateHandler = { [weak self] _ in
            guard let strongSelf = self else { return }
            let willPause = strongSelf.playbackButton.isPlayShown
            strongSelf.delegate?.videoPlaybackControlDidTapPlaybackButton(strongSelf, willPlay: !willPause)
        }
        addSubview(playbackButton)
        playbackButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        settingButton.setSystemImage("gearshape")
        settingButton.configuration = .plain().update {
            $0.baseForegroundColor = .white
            $0.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
            $0.contentInsets = .all(5)
        }
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

private final class PlaybackButton: UIButton {
    
    var isPlayShown: Bool {
        get {
            isSelected
        }
        set {
            isSelected = newValue
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
        setSystemImage("pause.fill", for: .normal)
        setSystemImage("play.fill", for: .selected)
        
        configuration = UIButton.Configuration.filled().update {
            $0.cornerStyle = .capsule
            $0.baseForegroundColor = .white
            $0.background.backgroundColor = .black.withAlphaComponent(0.3)
            $0.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
            $0.contentInsets = .all(10)
        }
        
        addAction(UIAction { [weak self] _ in
            self?.isSelected.toggle()
        }, for: .touchUpInside)
    }
}
