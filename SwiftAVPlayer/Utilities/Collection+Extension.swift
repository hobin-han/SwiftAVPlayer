//
//  Collection+Extension.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 8/5/25.
//

extension Collection where Index == Int {
    
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
