//
//  TooltipView.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/11/24.
//

import UIKit
import SnapKit

enum TooltipPosition {
    case top
    case bottom
}

enum TrianglePosition {
    case left
    case center
    case right
}

class TooltipView: UIView {
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let triangleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo
        view.layer.cornerRadius = 8
        return view
    }()
    
    var tooltipPosition: TooltipPosition = .top
    var trianglePosition: TrianglePosition = .center
    var shapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(contentLabel)
        addSubview(triangleView)
        
        updateConstraintsTooltip()
    }
    
    private func updateConstraintsTooltip() {
        // Remove existing constraints
        containerView.snp.removeConstraints()
        triangleView.snp.removeConstraints()
        contentLabel.snp.removeConstraints()
        
        switch tooltipPosition {
        case .top:
            containerView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.bottom.equalTo(triangleView.snp.top)
            }
            
            triangleView.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.height.equalTo(10)
                make.width.equalTo(20)
                
                switch trianglePosition {
                case .left:
                    make.leading.equalToSuperview().offset(20)
                case .center:
                    make.centerX.equalToSuperview()
                case .right:
                    make.trailing.equalToSuperview().offset(-20)
                }
            }
            
        case .bottom:
       
            triangleView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(10)
                make.width.equalTo(20)
                
                switch trianglePosition {
                case .left:
                    make.leading.equalToSuperview().offset(20)
                case .center:
                    make.centerX.equalToSuperview()
                case .right:
                    make.trailing.equalToSuperview().offset(-20)
                }
            }
            
            containerView.snp.makeConstraints { make in
                make.bottom.leading.trailing.equalToSuperview()
                make.top.equalTo(triangleView.snp.bottom)
            }
            
        }
        
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        updateTrianglePath()
    }
    
    private func updateTrianglePath() {
        // Remove existing shape layer
        shapeLayer?.removeFromSuperlayer()
        
        let trianglePath = UIBezierPath()
        
        switch tooltipPosition {
        case .top:
            // Triangle pointing down
            trianglePath.move(to: CGPoint(x: 0, y: 0))
            trianglePath.addLine(to: CGPoint(x: 20, y: 0))
            trianglePath.addLine(to: CGPoint(x: 10, y: 10))
        case .bottom:
            // Triangle pointing up
            trianglePath.move(to: CGPoint(x: 0, y: 10))
            trianglePath.addLine(to: CGPoint(x: 20, y: 10))
            trianglePath.addLine(to: CGPoint(x: 10, y: 0))
        }
        
        trianglePath.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = trianglePath.cgPath
        shapeLayer.fillColor = UIColor.systemIndigo.cgColor
        triangleView.layer.addSublayer(shapeLayer)
        self.shapeLayer = shapeLayer
    }
    
    func configure(with text: String, tooltipPosition: TooltipPosition = .top, trianglePosition: TrianglePosition = .center) {
        contentLabel.text = text
        self.tooltipPosition = tooltipPosition
        self.trianglePosition = trianglePosition
        updateConstraintsTooltip()
    }
}
