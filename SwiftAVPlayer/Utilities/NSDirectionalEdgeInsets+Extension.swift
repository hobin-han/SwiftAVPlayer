//
//  NSDirectionalEdgeInsets+Extension.swift
//  SwiftAVPlayer
//
//  Created by Hobin Han on 8/30/25.
//

import UIKit

extension NSDirectionalEdgeInsets {
    
    static func all(_ all: CGFloat) -> NSDirectionalEdgeInsets {
        .init(top: all, leading: all, bottom: all, trailing: all)
    }
}
