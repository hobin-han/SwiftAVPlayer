//
//  VideoTableViewCell.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/3/25.
//

import UIKit
import SnapKit

class VideoTableViewCell: UITableViewCell {
    
    private var mediaView: MediaView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let mediaView = MediaView()
        contentView.addSubview(mediaView)
        
        mediaView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.mediaView = mediaView
    }
    
    func set(_ urlString: String) {
        mediaView.url = URL(string: urlString)
    }
    
    func play() {
        mediaView.player.play()
    }
    
    func pause() {
        mediaView.player.pause()
    }
}
