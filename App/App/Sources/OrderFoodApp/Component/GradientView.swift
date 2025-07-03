//
//  GradientView.swift
//  OrderFoodApp
//
//  Created by Phincon on 18/03/25.
//

import Foundation
import UIKit


class GradientView: UIView {
    
    var cornerRadius: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        applyShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        applyShadow()
    }
    
    func applyShadow() {
        self.addShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1),
            offset: CGSize(width: 0, height: 2),
            opacity: 0.5,
            radius: 5,
            path: nil)
        self.layer.masksToBounds = false
    }
    
    func setup() {
        self.addBorderLine(width: 0.5, color: UIColor(white: 0, alpha: 0.05))
        self.backgroundColor = .foodWhite100
        self.makeCornerRadius(20, maskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner])
    }
}
