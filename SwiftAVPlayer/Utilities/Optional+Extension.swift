//
//  Optional+Extension.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 8/12/25.
//

extension Optional where Wrapped: Error {
    
    var localizedDescription: String {
        self?.localizedDescription ?? "? unknown error ?"
    }
}
