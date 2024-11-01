//
//  FloatingIconView.swift
//  OrderFoodApp
//
//  Created by Phincon on 03/10/24.
//

import Foundation
import UIKit

protocol FloatingIconViewDelegate {
    func actionTap()
}

class FloatingIconView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var delegate: FloatingIconViewDelegate?
    
    // Inisialisasi dengan gambar
    init(image: UIImage) {
        super.init(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: UIScreen.main.bounds.height - 180 , width: 80, height: 80))
        setupView(image: image)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView(image: UIImage) {
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
        self.backgroundColor = .clear
        
        imageView.image = image
        imageView.frame = self.bounds
        addSubview(imageView)
    }
    
    private func setupGesture() {
        // Gesture untuk drag
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
        
        // Gesture untuk tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        gesture.setTranslation(.zero, in: self.superview)
        
        if gesture.state == .ended {
            let velocity = gesture.velocity(in: self.superview)
            let finalX: CGFloat
            let screenWidth = UIScreen.main.bounds.width
            
            // Tentukan arah geser otomatis ke kiri atau kanan berdasarkan kecepatan
            if velocity.x > 0 {
                finalX = screenWidth - self.bounds.width / 2 - 10 // geser ke kanan
            } else {
                finalX = self.bounds.width / 2 + 10 // geser ke kiri
            }
            
            UIView.animate(withDuration: 0.3) {
                self.center.x = finalX
            }
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        // Lakukan sesuatu saat icon di-tap
        print("Floating icon tapped!")
        
        delegate?.actionTap()
        
 
    }
}
