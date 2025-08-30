//
//  VideoPlaybackControlView.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 8/12/25.
//

import UIKit

@MainActor protocol VideoPlaybackControlDelegate: AnyObject {
    func videoPlaybackControlDidTapPlaybackButton(_ control: VideoPlaybackControlView, willPlay: Bool)
    func videoPlaybackControlDidTapSkipButton(_ control: VideoPlaybackControlView, toSeconds: Double)
    func videoPlaybackControlDidTapSettingButton(_ control: VideoPlaybackControlView)
}

final class VideoPlaybackControlView: UIView {
    
    weak var delegate: VideoPlaybackControlDelegate?
    
    private let filledButtonConfig = UIButton.Configuration.filled().update {
        $0.cornerStyle = .capsule
        $0.baseForegroundColor = .white
        $0.background.backgroundColor = .black.withAlphaComponent(0.3)
        $0.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        $0.contentInsets = .all(8)
    }
    private let plainButtonConfig = UIButton.Configuration.plain().update {
        $0.baseForegroundColor = .white
        $0.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        $0.contentInsets = .all(8)
    }
    
    private let playbackButton = PlaybackButton()
    private let skipBackward10SecButton = UIButton()
    private let skipForward10SecButton = UIButton()
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
        
        setupPlayerButtons()
        setupSettingButton()
    }
    
    private func setupPlayerButtons() {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 20
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        playbackButton.configuration = filledButtonConfig.update {
            $0.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
            $0.contentInsets = .all(10)
        }
        playbackButton.configurationUpdateHandler = { [weak self] _ in
            guard let strongSelf = self else { return }
            let willPause = strongSelf.playbackButton.isPlayShown
            strongSelf.delegate?.videoPlaybackControlDidTapPlaybackButton(strongSelf, willPlay: !willPause)
        }
        
        skipBackward10SecButton.setSystemImage("10.arrow.trianglehead.counterclockwise")
        skipBackward10SecButton.configuration = filledButtonConfig
        skipBackward10SecButton.addAction(UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.videoPlaybackControlDidTapSkipButton(strongSelf, toSeconds: -10)
        }, for: .touchUpInside)
        
        skipForward10SecButton.setSystemImage("10.arrow.trianglehead.clockwise")
        skipForward10SecButton.configuration = filledButtonConfig
        skipForward10SecButton.addAction(UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.videoPlaybackControlDidTapSkipButton(strongSelf, toSeconds: +10)
        }, for: .touchUpInside)
        
        [skipBackward10SecButton, playbackButton, skipForward10SecButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupSettingButton() {
        settingButton.setSystemImage("gearshape")
        settingButton.configuration = plainButtonConfig
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
        
        addAction(UIAction { [weak self] _ in
            self?.isSelected.toggle()
        }, for: .touchUpInside)
    }
}
