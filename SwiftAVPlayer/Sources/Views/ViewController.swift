//
//  ViewController.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/1/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var mediaView: MediaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMediaView()
    }
    
    private func setMediaView() {
        let mediaView = MediaView()
        view.addSubview(mediaView)
        
        mediaView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let urlString = "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8"
        mediaView.url = URL(string: urlString)
        
        mediaView.player.play()
        
        self.mediaView = mediaView
    }
}
