//
//  ProgressView.swift
//  SwiftAVPlayer
//
//  Created by hobin-han on 7/7/25.
//

import UIKit
import SnapKit

class ProgressView: UIView {
    
    private let fillView = UIView()
    
    var foregroundColor: UIColor? {
        get {
            fillView.backgroundColor
        }
        set {
            fillView.backgroundColor = newValue
        }
    }
    
    /// range of the value should be 0.0 ~ 1.0
    var rate: CGFloat = 0 {
        didSet {
            fillWidthConstraint.update(offset: estimatedFillWidth)
        }
    }
    
    private var estimatedFillWidth: CGFloat {
        rate * bounds.width
    }
    
    private var fillWidthConstraint: Constraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white.withAlphaComponent(0.3)
        foregroundColor = .white.withAlphaComponent(0.7)
        
        addSubview(fillView)
        fillView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            fillWidthConstraint = $0.width.equalTo(estimatedFillWidth).constraint
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fillWidthConstraint.update(offset: estimatedFillWidth)
    }
}
