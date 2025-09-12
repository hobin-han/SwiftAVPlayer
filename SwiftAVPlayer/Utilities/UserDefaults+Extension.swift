//
//  UserDefaults+Extension.swift
//  SwiftAVPlayer
//
//  Created by Hobin Han on 9/12/25.
//

import Foundation

extension UserDefaults {
    
    var lastRefreshDateString: String {
        get {
            string(forKey: "lastRefreshDateString") ?? ""
        }
        set {
            set(newValue, forKey: "lastRefreshDateString")
            synchronize()
        }
    }
}
