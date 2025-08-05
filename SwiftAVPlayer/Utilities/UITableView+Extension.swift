//
//  UITableView+Extension.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 7/3/25.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? T
    }
}
