//
//  CircularProgressView.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import Foundation
import UIKit
import SwiftUI

//struct CustomButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        previewView(MultiCircularProgressView())
//            .frame(width: 100, height: 50) // Atur ukuran tampilan
//    }
//}

class CircularProgressView: UIView {
    
    // Configuration for the circle layers
    let trackLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        // Define circular path
        let centerPoint = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: 100, startAngle: -.pi / 2, endAngle: 1.5 * .pi, clockwise: true)
        
        // Track Layer (Background circle)
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.strokeEnd = 1
        layer.addSublayer(trackLayer)
        
        // Progress Layer (Animated circle)
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.red.cgColor // Set color for progress
        progressLayer.lineWidth = 10
        progressLayer.strokeEnd = 0 // Start with no progress
        layer.addSublayer(progressLayer)
    }
    
    // Animate the progress from 0 to the desired value
    func setProgress(to progress: CGFloat, duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = progress
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "progressAnimation")
    }
}

import UIKit

class MultiCircularProgressView: UIView {
    
    // Array to store progress layers
    private var progressLayers: [CAShapeLayer] = []
    
    // Colors for each layer (example from image colors)
    private let colors: [UIColor] = [.green, .orange, .purple, .cyan]
    
    // Progress percentages (example from the image)
    private let progresses: [CGFloat] = [0.53, 0.64, 0.45, 0.47] // percentages for each layer
    
    // Line width for each layer
    private let lineWidths: [CGFloat] = [30, 30, 30, 30]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        let numberOfLayers = colors.count
        let centerPoint = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        for i in 0..<numberOfLayers {
            let radius = CGFloat(40 + i * 30) // increasing radius for each layer
            let circularPath = UIBezierPath(arcCenter: centerPoint,
                                            radius: radius,
                                            startAngle: -.pi / 2,
                                            endAngle: 1.5 * .pi,
                                            clockwise: true)
            
            let trackLayer = CAShapeLayer()
            trackLayer.path = circularPath.cgPath
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.strokeColor = UIColor.white.cgColor
            trackLayer.lineWidth = lineWidths[i]
            trackLayer.strokeEnd = 1
            trackLayer.lineCap = .round // Rounded ends for track layer (optional)
            layer.addSublayer(trackLayer)
            
            let progressLayer = CAShapeLayer()
            progressLayer.path = circularPath.cgPath
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.strokeColor = colors[i].cgColor
            progressLayer.lineWidth = lineWidths[i]
            progressLayer.strokeEnd = 0
            progressLayer.lineCap = .round // Rounded ends for progress layer
            progressLayers.append(progressLayer)
            layer.addSublayer(progressLayer)
        }
    }
    
    // Function to animate all layers
    func animateProgress(duration: TimeInterval) {
        for (index, progressLayer) in progressLayers.enumerated() {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.toValue = progresses[index]
            animation.duration = duration
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            progressLayer.add(animation, forKey: "progressAnimation\(index)")
        }
    }
}

