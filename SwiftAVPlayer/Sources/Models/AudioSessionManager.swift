//
//  AudioSessionManager.swift
//  SwiftAVPlayer
//
//  Created by hobin.han on 9/12/25.
//

import AVFAudio

enum AudioSessionManager {
    
    private static let session = AVAudioSession.sharedInstance()
    
    static func activate() {
        do {
            try session.setCategory(AVAudioSession.Category.playback, mode: .default, policy: .longFormVideo, options: [])
            try session.setActive(true)
        } catch {
            print("audio session activate error:", error.localizedDescription)
        }
    }
    
    static func deactivate() {
        do {
            try session.setActive(false)
        } catch {
            print("audio session deactivate error:", error.localizedDescription)
        }
    }
}
