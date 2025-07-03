//
//  Ext+UIView.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import Foundation
import UIKit

extension UIView {
    
    func add(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }

    
    func getViewController() -> UIViewController? {
         var nextResponder: UIResponder? = self
         while nextResponder != nil {
             nextResponder = nextResponder?.next
             if let viewController = nextResponder as? UIViewController {
                 return viewController
             }
         }
         return nil
     }
    
    func drawDottedBorder() {
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = 4
        dashBorder.strokeColor = UIColor.gray.cgColor
        let cornerRadius: CGFloat = 8
        dashBorder.lineDashPattern = [7, 3]
        dashBorder.frame = self.bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        self.layer.addSublayer(dashBorder)
    }
    
    //    Rotate a view by specified degrees
    //    parameter angle: angle in degrees
    //  */
     func setRotation(angle: CGFloat) {
         let radians = (angle / 180.0) * CGFloat.pi
         self.transform = CGAffineTransform(rotationAngle: radians)
     }
}

extension UIView {
    func makeCornerRadius(_ radius: CGFloat, maskedCorner: CACornerMask? = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]) {
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorner ?? [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        clipsToBounds = true
    }


    func addBorderLine(width: CGFloat = 1,
                       color: UIColor = .gray) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    func addShadow(color: UIColor = .black,
                   offset: CGSize = CGSize(width: 0, height: 3),
                   opacity: Float = 0.5,
                   radius: CGFloat = 2,
                   path: UIBezierPath? = nil) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = path?.cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
    
    
    // Function to add shadow to any UIView
    func addShadowToView(shadowRadius: CGFloat = 4.0) {
        self.layer.shadowColor = UIColor.black.cgColor   // Shadow color
        self.layer.shadowOpacity = 0.5                  // Shadow opacity (0.0 to 1.0)
        self.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset (width, height)
        self.layer.shadowRadius = shadowRadius                  // Shadow radius
        self.layer.masksToBounds = false                // Don't clip shadow to the bounds
    }
    
    func addTapGestureTarget(_ target: Any?, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    typealias TapAction = () -> Void
    func addTapGestureAction(_ action: @escaping TapAction) {
        isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: "TapAction".hashValue)!, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func handleGesture(_ sender: UITapGestureRecognizer) {
        if let action = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: "TapAction".hashValue)!) as? TapAction {
            action()
        }
    }
    

}
