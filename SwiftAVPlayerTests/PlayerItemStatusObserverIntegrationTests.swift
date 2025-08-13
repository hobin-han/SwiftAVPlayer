//
//  PlayerItemStatusObserverIntegrationTests.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 7/14/25.
//

import Foundation
import AVFoundation
@testable import SwiftAVPlayer
import Testing

class PlayerItemStatusObserverIntegrationTests {
    
    let observer = PlayerItemStatusObserver()
    
    @Test(arguments: [
        "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
        "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8",
        "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear1/prog_index.m3u8",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    ])
    func statusCallback(urlString: String) throws {
        let playerItem = URL(string: urlString).map { AVPlayerItem(url: $0) }
        try #require(playerItem != nil)
        guard let playerItem else { return }
        
        let sema = DispatchSemaphore(value: 0)
        let startDate = Date()
        var timeInterval: TimeInterval?
        
        observer.playerItem = playerItem
        observer.callback = { status in
            if status == .readyToPlay {
                timeInterval = Date().timeIntervalSince(startDate)
                sema.signal()
            }
        }
        
        _ = AVPlayer(playerItem: playerItem)
        
        let timeoutResult = sema.wait(timeout: .now() + 5)
        
        #expect(timeoutResult == .success)
        #expect(timeInterval != nil)
    }
}
