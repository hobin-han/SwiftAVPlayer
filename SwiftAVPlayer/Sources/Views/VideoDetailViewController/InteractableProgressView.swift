//
//  InteractableProgressView.swift
//  SwiftAVPlayer
//
//  Created by Hobin Han on 8/30/25.
//

import UIKit
import SnapKit

@MainActor protocol InteractableProgressViewDelegate: AnyObject {
    func interactableProgressView(_ progressView: InteractableProgressView, isInteracting: Bool)
    func interactableProgressView(_ progressView: InteractableProgressView, didChangeProgressTo value: Double)
}

final class InteractableProgressView: ProgressView {
    
    weak var delegate: InteractableProgressViewDelegate?
    
    let focusedFillView = UIView()
    let focusedAnchorView = UIView()
    
    private var anchorXConstraint: Constraint!
    private var changedDistance: CGFloat?
    
    private var dragStartX: CGFloat? {
        didSet {
            let isDragging = dragStartX != nil
            focusedFillView.isHidden = !isDragging
            focusedAnchorView.isHidden = !isDragging
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        focusedFillView.isHidden = true
        focusedFillView.backgroundColor = .systemRed
        addSubview(focusedFillView)
        focusedFillView.snp.makeConstraints {
            $0.edges.equalTo(fillView)
        }
        
        let diameter: CGFloat = 16
        focusedAnchorView.isHidden = true
        focusedAnchorView.backgroundColor = .systemRed
        focusedAnchorView.layer.cornerRadius = diameter / 2
        addSubview(focusedAnchorView)
        focusedAnchorView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: diameter, height: diameter))
            anchorXConstraint = $0.centerX.equalTo(focusedFillView.snp.trailing).constraint
        }
        
        let draggableView = DraggableView()
        draggableView.beganHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.focusedFillView.isHidden = false
            strongSelf.focusedAnchorView.isHidden = false
            strongSelf.delegate?.interactableProgressView(strongSelf, isInteracting: true)
        }
        draggableView.changedHandler = { [weak self] width in
            guard let strongSelf = self else { return }
            strongSelf.anchorXConstraint.update(offset: width - strongSelf.fillView.bounds.width)
            strongSelf.delegate?.interactableProgressView(strongSelf, didChangeProgressTo: Double(width))
        }
        draggableView.endedHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.focusedFillView.isHidden = true
            strongSelf.focusedAnchorView.isHidden = true
            strongSelf.delegate?.interactableProgressView(strongSelf, isInteracting: false)
        }
        addSubview(draggableView)
        draggableView.snp.makeConstraints {
            $0.leading.trailing.centerY.equalToSuperview()
            $0.height.equalToSuperview().offset(5)
        }
    }
}

private class DraggableView: UIView {
    
    var beganHandler: (() -> Void)?
    var changedHandler: ((CGFloat) -> Void)?
    var endedHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        addGestureRecognizer(dragGestureRecognizer)
    }
    
    @objc private func handleDrag(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            beganHandler?()
        case .changed:
            changedHandler?(gesture.location(in: self).x)
        case .ended, .cancelled, .failed:
            endedHandler?()
        default: break
        }
    }
}
