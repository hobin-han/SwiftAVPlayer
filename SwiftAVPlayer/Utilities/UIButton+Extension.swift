//
//  UIButton+Extension.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 8/12/25.
//

import UIKit

extension UIButton {
    
    func setSystemImage(_ name: String, for state: UIControl.State = .normal) {
        setImage(UIImage(systemName: name), for: state)
    }
}

extension UIButton.Configuration {
    
    func update(_ handler: (inout Self) -> Void) -> Self {
        var copy = self
        handler(&copy)
        return copy
    }
}
