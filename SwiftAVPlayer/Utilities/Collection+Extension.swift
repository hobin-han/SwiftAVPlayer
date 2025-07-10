//
//  Collection+Extension.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/10/25.
//

extension Collection where Index == Int {
    
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
