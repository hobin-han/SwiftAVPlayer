//
//  ViewController.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/1/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        let button = UIButton(configuration: .filled())
        button.setTitle("show Video List", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let videoListVC = VideoListViewController()
        navigationController?.pushViewController(videoListVC, animated: true)
    }
}
