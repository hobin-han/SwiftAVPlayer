//
//  RetroVideoPlaybackController.swift
//  SwiftAVPlayer
//
//  Created by bamiboo.han on 7/8/25.
//

import UIKit
import SnapKit

class RetroVideoPlaybackController: UIViewController {
    
    private var stackView: UIStackView!
    private var focusView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
    }
    
    private func setupView() {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalToSuperview().inset(20)
            $0.width.lessThanOrEqualTo(400)
            $0.width.lessThanOrEqualToSuperview().inset(10)
            $0.width.equalToSuperview().priority(.high)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.width.centerX.equalToSuperview()
        }
        self.stackView = stackView
        
        let focusView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        focusView.layer.borderColor = UIColor.systemPurple.cgColor
        focusView.layer.borderWidth = 10
        view.addSubview(focusView)
        self.focusView = focusView
        
        setupContentViews(repeating: 5)
    }
    
    private func setupContentViews(repeating count: Int) {
        for _ in 0..<count {
            let testView = UIView()
            testView.backgroundColor = .random
            stackView.addArrangedSubview(testView)
            testView.snp.makeConstraints {
                $0.height.equalTo(testView.snp.width).multipliedBy(9.0 / 16.0)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        focusToCenter()
    }
    
    private func focusToCenter() {
        guard let index = findCenterContentViewIndex(),
              let contentView = stackView.arrangedSubviews[safe: index],
              let superview = focusView.superview else { return }
        
        let frame = contentView.convert(contentView.bounds, to: superview)
        focusView.frame = frame
    }
    
    private func findCenterContentViewIndex() -> Int? {
        guard let centerView = view.hitTest(view.center, with: nil),
              let index = stackView.arrangedSubviews.enumerated().first(where: { $0.element === centerView })?.offset else { return nil }
        return index
    }
}

extension RetroVideoPlaybackController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollEnd()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        handleScrollEnd()
    }
    
    private func handleScrollEnd() {
        print("handleScrollEnd", Date())
    }
}
