//
//  MultiDataCircularGraph.swift
//  OrderFoodApp
//
//  Created by Phincon on 19/03/25.
//

import Foundation
import UIKit

protocol MultiDataCircularGraphDelegate {
    func tapMiddleSection()
}

class MultiDataCircularGraph: UIView {
    enum MiddleInfoStyle {
        case small
        case big
    }
    
    var isAnimate: Bool = true
    
    private var trackLayer = CAShapeLayer()
    private var middleInfoContainer = UIView()
    private let stackContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        return button
    }()
    
    private let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.textAlignment = .center
        return topLabel
    }()
    
    private let bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        return bottomView
    }()
    
    private let bottomStack: UIStackView = {
        let bottomStack = UIStackView()
        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.spacing = 4
        return bottomStack
    }()

    private let bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.textColor = UIColor.gray
        bottomLabel.textAlignment = .center
        return bottomLabel
    }()
    
    private let bottomIcon: UIImageView = {
        let bottomIcon = UIImageView()
        bottomIcon.backgroundColor = .clear
        bottomIcon.image = UIImage(named: "dashboard_limit_balance_chevron_down")?.withRenderingMode(.alwaysTemplate)
        bottomIcon.tintColor = UIColor.gray
        return bottomIcon
    }()

    private var isBottomSheetOpened: Bool = false
    var delegate: MultiDataCircularGraphDelegate?
    var hexColorsArray: [String] = []
    var percentageData: [CGFloat] = [] {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    internal func setupData(values: [Int], hexColorsArray: [String] = [], isAnimate: Bool = true) {
        self.isAnimate = isAnimate
        if hexColorsArray.isEmpty == true {
            self.hexColorsArray = ["6F0110", "C9011D", "FF0125", "F75D01"] // Default Colors
        } else {
            self.hexColorsArray = hexColorsArray
        }
        
        let totalValue = values.reduce(0, {$0 + $1})
        
        self.percentageData = values.compactMap({ singleValue in
            let percentage = CGFloat(singleValue) / CGFloat(totalValue)
            return percentage
        })
    }
    
    private func setupLayers() {
        // Set up track layer
        trackLayer.lineWidth = 25
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.darkGray.cgColor
        layer.addSublayer(trackLayer)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        let lineWidth = radius * 0.24
        let adjustedRadius = radius - lineWidth / 2
                
        // Draw track layer
        let trackPath = UIBezierPath(arcCenter: center, radius: adjustedRadius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = trackPath.cgPath
        trackLayer.lineWidth = lineWidth
        
        var progressStartAngle: CGFloat = -CGFloat.pi / 2
        
        func animateSegment(at index: Int) {
            guard index < self.percentageData.count else { return }
            
            let percentage = self.percentageData[index]
            let progressLayer = CAShapeLayer()
            progressLayer.lineWidth = 25
            progressLayer.fillColor = UIColor.clear.cgColor
            
            if index > self.hexColorsArray.count-1 {
                progressLayer.strokeColor = UIColor.clear.cgColor
            } else {
                progressLayer.strokeColor = UIColor(hex: hexColorsArray[index]).cgColor
            }
            
            self.layer.addSublayer(progressLayer)
            
            var progressEndAngle: CGFloat = 0
            
            // Update the end angle
            if index == 0 {
                progressEndAngle = 2 * CGFloat.pi * percentage - CGFloat.pi / 2
            } else {
                progressEndAngle = progressStartAngle + 2 * CGFloat.pi * percentage
            }
            
            // Draw the progress
            let progressPath = UIBezierPath(arcCenter: center, radius: adjustedRadius, startAngle: progressStartAngle, endAngle: progressEndAngle, clockwise: true)
            progressLayer.path = progressPath.cgPath
            progressLayer.lineWidth = lineWidth
            
            if isAnimate {
                // Animate the progress layer
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.fromValue = 0
                animation.toValue = 1
                let duration = percentage * 0.7 // percentage * totalTime
                animation.duration = duration
                animation.timingFunction = CAMediaTimingFunction(name: .linear)
                
                progressLayer.add(animation, forKey: "drawAnimation")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration) {
                    animateSegment(at: index + 1)
                }
            } else {
                progressLayer.strokeEnd = 1.0
                DispatchQueue.main.async {
                    animateSegment(at: index + 1)
                }
            }
            
            // Set the new start angle for the next data
            progressStartAngle = progressEndAngle
        }
        
        layer.sublayers?.filter { $0 is CAShapeLayer && $0 != trackLayer }.forEach { $0.removeFromSuperlayer() }
        
        animateSegment(at: 0)
    }
    
    internal func setupMiddleInfo(topText: String, bottomText: String, style: MiddleInfoStyle) {
        topLabel.text = topText
        bottomLabel.text = bottomText
        bottomLabel.sizeToFit()
        // Add Subviews
        self.middleInfoContainer.addSubview(stackContainer)
        self.middleInfoContainer.addSubview(actionButton)
        stackContainer.addArrangedSubview(topLabel)
        stackContainer.addArrangedSubview(bottomView)
        bottomView.addSubview(bottomStack)
        bottomStack.addArrangedSubview(bottomLabel)
        self.middleInfoContainer.bringSubviewToFront(actionButton)
        
        switch style {
        case .small:
            topLabel.font = UIFont.foodSemiBold(12)
            bottomLabel.font = UIFont.foodSemiBold(10)
            bottomIcon.isHidden = true
            stackContainer.spacing = 4
        case .big:
            topLabel.font = UIFont.foodSemiBold(24)
            bottomLabel.font = UIFont.foodSemiBold(14)
            bottomIcon.isHidden = false
            stackContainer.spacing = 8
            bottomStack.addArrangedSubview(bottomIcon)
            actionButton.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        }

        // Set Constraints
        stackContainer.snp.makeConstraints { make in
            let radius = min(bounds.width, bounds.height) / 2
            make.width.equalTo(radius * 1.5)
            make.center.equalToSuperview()
        }

        actionButton.snp.makeConstraints { make in
            let radius = min(bounds.width, bounds.height) / 2
            make.width.equalTo(radius * 1.5)
            make.height.equalTo(60)
            make.center.equalToSuperview()
        }
        
        bottomStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        if style == .big {
            bottomIcon.snp.makeConstraints { make in
                make.height.equalTo(16)
            }
        }

        self.addSubview(middleInfoContainer)
        self.bringSubviewToFront(middleInfoContainer)
        
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    @objc
    func handleTapGesture() {
        self.arrowToggle(isOpen: true)
        self.delegate?.tapMiddleSection()
    }
    
    func arrowToggle(isOpen: Bool) {
        self.isBottomSheetOpened = isOpen
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.bottomIcon.setRotation(angle: self.isBottomSheetOpened ? 180 : 0 )
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        
        middleInfoContainer.frame = CGRect(x: 0, y: 0, width: radius * 1.44, height: radius * 1.44)
        middleInfoContainer.center = center
        
    }
}
