//
//  Collection+Extension.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/28/25.
//

extension Collection {
    
    subscript(safe index: Index?) -> Element? {
        guard let index, indices.contains(index) else { return nil }
        return self[index]
    }
}
