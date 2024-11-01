//
//  AnimationViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 07/10/24.
//

import UIKit

class AnimationViewController: UIViewController {
    @IBOutlet weak var animatedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 00, y: 150))
        
        // Example control points for a smooth curve similar to the image
        path.addCurve(to: CGPoint(x: 80, y: 120), controlPoint1: CGPoint(x: 40, y: 200), controlPoint2: CGPoint(x: 60, y: 80))
        path.addCurve(to: CGPoint(x: 140, y: 180), controlPoint1: CGPoint(x: 100, y: 160), controlPoint2: CGPoint(x: 120, y: 220))
        path.addCurve(to: CGPoint(x: 200, y: 100), controlPoint1: CGPoint(x: 160, y: 140), controlPoint2: CGPoint(x: 180, y: 60))
        path.addCurve(to: CGPoint(x: 260, y: 140), controlPoint1: CGPoint(x: 220, y: 140), controlPoint2: CGPoint(x: 240, y: 200))
        path.addCurve(to: CGPoint(x: 320, y: 90), controlPoint1: CGPoint(x: 280, y: 100), controlPoint2: CGPoint(x: 300, y: 70))
        path.addCurve(to: CGPoint(x: self.view.frame.width, y: 150), controlPoint1: CGPoint(x: 340, y: 110), controlPoint2: CGPoint(x: 360, y: 180))
        
        
        path.lineWidth = CGFloat(2.0)
        
        // Create a CAShapeLayer to render the UIBezierPath
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath  // Use the cgPath of UIBezierPath
        // Set stroke color (for the border)
        shapeLayer.strokeColor = UIColor.red.cgColor
        // Set fill color (for the inside)
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        // Set line width for the stroke
        shapeLayer.lineWidth = 3.0
        
        self.view.layer.addSublayer(shapeLayer)
        
        
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 3.0
        
        animation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut),
                                     CAMediaTimingFunction(name: .linear)
        ]
        
        self.animatedView.layer.add(animation, forKey: "pathAnimation")
        
    }
    
}

class ChartView: UIView {
    override func draw(_ rect: CGRect) {
        // Define the path using UIBezierPath
        let path = UIBezierPath()

        // Starting point (left side of the graph)
        path.move(to: CGPoint(x: 20, y: 150))
        
        // Example control points for a smooth curve similar to the image
        path.addCurve(to: CGPoint(x: 80, y: 120), controlPoint1: CGPoint(x: 40, y: 200), controlPoint2: CGPoint(x: 60, y: 80))
        path.addCurve(to: CGPoint(x: 140, y: 180), controlPoint1: CGPoint(x: 100, y: 160), controlPoint2: CGPoint(x: 120, y: 220))
        path.addCurve(to: CGPoint(x: 200, y: 100), controlPoint1: CGPoint(x: 160, y: 140), controlPoint2: CGPoint(x: 180, y: 60))
        path.addCurve(to: CGPoint(x: 260, y: 140), controlPoint1: CGPoint(x: 220, y: 140), controlPoint2: CGPoint(x: 240, y: 200))
        path.addCurve(to: CGPoint(x: 320, y: 90), controlPoint1: CGPoint(x: 280, y: 100), controlPoint2: CGPoint(x: 300, y: 70))
        path.addCurve(to: CGPoint(x: 380, y: 150), controlPoint1: CGPoint(x: 340, y: 110), controlPoint2: CGPoint(x: 360, y: 180))
        
        // Continue adding more points based on the desired curve
        // You can adjust these control points to match the curve in the image more precisely

        // Set the stroke color and width
        UIColor.red.setStroke()
        path.lineWidth = 4.0
        
        // Draw the path
        path.stroke()
    }
}
