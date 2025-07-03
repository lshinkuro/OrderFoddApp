//
//  GradientColorView.swift
//  OrderFoodApp
//
//  Created by Phincon on 11/10/24.
//

import UIKit

class GradientColorView: UIView {

    var cornerRadius: CGFloat = 10
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        applyShadow(on: self.frame)
    }
    
    func applyShadow(on rect: CGRect) {
        self.addShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1),
            offset: CGSize(
                width: 0,
                height: 2),
            opacity: 0.5,
            radius: 5,
            path: nil)
        self.layer.masksToBounds = false
    }
    
    func addGradientBackground(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        // Set the colors for the gradient
        gradientLayer.colors = colors.map { $0.cgColor }
        
        // Define the start and end points (0,0) is top-left, (1,1) is bottom-right
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        // Optionally set the locations for color stops (e.g. fade effect)
        gradientLayer.locations = [0, 1]
        
        // Add the gradient layer to the view
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    func setup() {
        self.addBorderLine(width: 0.5, color: UIColor(white: 0, alpha: 0.05))
        self.backgroundColor = .foodWhite100
        self.makeCornerRadius(20, maskedCorner: [[.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]])
    }
}
