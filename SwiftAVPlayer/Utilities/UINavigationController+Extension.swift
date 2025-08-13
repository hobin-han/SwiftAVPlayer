//
//  UINavigationController+Extension.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 8/5/25.
//

import UIKit

extension UINavigationController {
    
    func setRootViewController(_ viewController: UIViewController) {
        popToRootViewController(animated: false)
        pushViewController(viewController, animated: false)
    }
}
