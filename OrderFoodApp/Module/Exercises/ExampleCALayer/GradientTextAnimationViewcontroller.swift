//
//  GradientTextAnimationViewcontroller.swift
//  OrderFoodApp
//
//  Created by Phincon on 13/03/25.
//

import UIKit

class GradientTextAnimationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black  // Agar kontras dengan efeknya
        setupGradientText()
    }
    
    private func setupGradientText() {
        let text = "WAVY TEXT"
        
        // 1️⃣ Buat Text Layer
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.font = UIFont.boldSystemFont(ofSize: 50)
        textLayer.fontSize = 50
        textLayer.alignmentMode = .center
        textLayer.frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: 80)
        textLayer.foregroundColor = UIColor.white.cgColor // Warna tidak akan terlihat karena ada mask
        
        // 2️⃣ Buat Gradient Layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = textLayer.bounds
        gradientLayer.colors = [
            UIColor.red.cgColor,
            UIColor.orange.cgColor,
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // 3️⃣ Gunakan Gradient sebagai Mask
        gradientLayer.mask = textLayer
        
        // 4️⃣ Tambahkan ke View
        view.layer.addSublayer(gradientLayer)
        
        // 5️⃣ Animasi Gradient Bergerak ke Kanan
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [-1.0, -0.5, 0.0]
        gradientAnimation.toValue = [1.0, 1.5, 2.0]
        gradientAnimation.duration = 3.0
        gradientAnimation.repeatCount = .infinity
        
        gradientLayer.add(gradientAnimation, forKey: "gradientAnimation")
    }
}
