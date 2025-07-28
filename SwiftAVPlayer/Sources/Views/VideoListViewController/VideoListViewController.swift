//
//  VideoListViewController.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/3/25.
//

import UIKit

class VideoListViewController: UITableViewController {
    
    private let videos = VideoDTO.loadDummyList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(VideoTableViewCell.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCenteredVideoCell()?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getCenteredVideoCell()?.pause()
    }
    
    private func getCenteredVideoCell() -> VideoTableViewCell? {
        guard let window = view.window else { return nil }
        
        let cell = tableView.visibleCells.first {
            let point = window.convert(window.center, to: $0)
            return $0.bounds.contains(point)
        }
        
        return cell as? VideoTableViewCell
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
            cell.readyToPlay = { [weak self, weak cell] in
                guard let strongSelf = self, let cell,
                      !tableView.isDragging, !tableView.isDecelerating,
                      strongSelf.getCenteredVideoCell() === cell else { return }
                cell.play()
            }
            cell.apply(video.urlString)
            return cell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        getCenteredVideoCell()?.pause()
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        getCenteredVideoCell()?.pause()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        getCenteredVideoCell()?.play()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        getCenteredVideoCell()?.play()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController = VideoDetailViewController()
        detailViewController.urlString = videos[safe: indexPath.row]?.urlString
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
