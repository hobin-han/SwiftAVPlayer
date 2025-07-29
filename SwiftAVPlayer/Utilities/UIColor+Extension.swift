//
//  UIColor+Extension.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/9/25.
//

import UIKit

extension UIColor {
    
    static var random: UIColor {
        UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )
    }
}
