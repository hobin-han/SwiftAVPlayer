//
//  VideoListViewController.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/3/25.
//

import UIKit

class VideoListViewController: UITableViewController {
    struct VideoData {
        let urlString: String
    }
    
    private let videos: [VideoData] = [
        VideoData(urlString: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(VideoTableViewCell.self)
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withType: VideoTableViewCell.self, for: indexPath) {
            let video = videos[indexPath.row]
            cell.set(video.urlString)
            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? VideoTableViewCell {
            cell.play()
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? VideoTableViewCell {
            cell.pause()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
