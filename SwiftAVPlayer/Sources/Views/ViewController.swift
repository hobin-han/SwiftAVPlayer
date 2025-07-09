//
//  ViewController.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/1/25.
//

import UIKit
import SnapKit

enum AppPage: String, CaseIterable {
    case videoListViewController                = "VideoListViewController"
    case retroVideoPlaybackController           = "RetroVideoPlaybackController"
    
    var type: UIViewController.Type {
        switch self {
        case .videoListViewController:          VideoListViewController.self
        case .retroVideoPlaybackController:     RetroVideoPlaybackController.self
        }
    }
}

class ViewController: UITableViewController {
    
    private let pages = AppPage.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withType: UITableViewCell.self, for: indexPath) {
            let page = pages[indexPath.row]
            cell.textLabel?.text = page.rawValue
            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let page = pages[indexPath.row]
        navigationController?.pushViewController(page.type.init(), animated: true)
    }
}
