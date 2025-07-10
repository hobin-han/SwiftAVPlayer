//
//  VideoTableViewCell.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/3/25.
//

import UIKit
import SnapKit

class VideoTableViewCell: UITableViewCell {
    
    private var errorLabel: UILabel!
    private var playerView: PlayerView!
    private var progressView: ProgressView!
    
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
        
        playerView.playerItem = nil // observers are removed here
        
        backgroundColor = nil
        errorLabel.text = nil
        playerView.isHidden = true
        progressView.rate = 0
        progressView.isHidden = true
        
        isDisplaying = false
    }
    
    private func setupView() {
        let errorLabel = UILabel()
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        contentView.addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.lessThanOrEqualToSuperview().inset(10)
        }
        self.errorLabel = errorLabel
        
        let playerView = PlayerView()
        playerView.isHidden = true
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
        guard playerView.playerItem?.status == .readyToPlay else { return }
        playerView.player.play()
    }
    
    func pause() {
        playerView.player.pause()
    }
    
    private func observe() {
        playerView.statusObserver.callback = { [weak self] status in
            guard let strongSelf = self else { return }
            switch status {
            case .readyToPlay:
                strongSelf.backgroundColor = .black
                strongSelf.playerView.isHidden = false
                strongSelf.progressView.isHidden = false
                
                if strongSelf.isDisplaying {
                    strongSelf.playerView.player.play()
                }
            case .failed:
                let error = strongSelf.playerView.playerItem?.error
                strongSelf.handleError(error)
            default: break
            }
        }
        
        playerView.timeObserver.callback = { [weak self] seconds in
            guard let strongSelf = self,
                  let duration = strongSelf.playerView.playerItem?.duration.seconds, duration > 0 else { return }
            let progressRate = CGFloat(seconds / duration)
            strongSelf.progressView.rate = progressRate
        }
        
        playerView.failToPlayToEndObserver.callback = { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.backgroundColor = nil
            strongSelf.playerView.isHidden = true
            strongSelf.handleError(error)
        }
    }
    
    /*
     (Example)
     -999       cancelled
     -1001      The request timed out.
     -1008      resource unavailable
     -1100      The requested URL was not found on this server.
     -1102      You do not have permission to access the requested resource.
     -11800     The operation could not be completed
     -11850     Operation Stopped
     */
    private func handleError(_ error: Error?) {
        let errorMsg = error?.localizedDescription ?? "unknown error"
        let code = (error as? NSError).map { "\($0.code)" } ?? "-"
        let codeMsg = "[code: \(code)]"
        errorLabel.text = errorMsg + "\n" + codeMsg
    }
}
