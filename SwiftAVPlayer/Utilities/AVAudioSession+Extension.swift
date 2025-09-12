//
//  AVAudioSession+Extension.swift
//  SwiftAVPlayer
//
//  Created by Hobin Han on 9/12/25.
//

import AVFAudio

extension AVAudioSession {
    
    func activate() {
        do {
            try setCategory(AVAudioSession.Category.playback, mode: .default, policy: .longFormVideo, options: [])
            try setActive(true)
        } catch {
            print("audio session activate error:", error.localizedDescription)
        }
    }
    
    func deactivate() {
        do {
            try setActive(false)
        } catch {
            print("audio session deactivate error:", error.localizedDescription)
        }
    }
}
