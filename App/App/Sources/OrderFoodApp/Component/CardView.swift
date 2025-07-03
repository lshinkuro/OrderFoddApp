//
//  CardView.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/11/24.
//

import UIKit
import SnapKit

class CardView: UIView {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let professionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var initialCenter: CGPoint = .zero
    
    var onCardRemoved: ((SwipeDirection) -> Void)? = nil

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        
        addSubview(imageView)
        addSubview(infoContainer)
        infoContainer.addSubview(nameLabel)
        infoContainer.addSubview(professionLabel)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        infoContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        professionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            initialCenter = center
            
        case .changed:
            center = CGPoint(x: initialCenter.x + translation.x,
                           y: initialCenter.y)
            
            // Rotate card while dragging
            let rotationAngle = translation.x / 320 * 0.4
            transform = CGAffineTransform(rotationAngle: rotationAngle)
            
        case .ended:
            let velocity = gesture.velocity(in: self)
            
            if translation.x > 100 || velocity.x > 500 {
                // Right swipe - like
                animateOffScreen(direction: .right)
            } else if translation.x < -100 || velocity.x < -500 {
                // Left swipe - dislike
                animateOffScreen(direction: .left)
            } else {
                // Reset position
                UIView.animate(withDuration: 0.2) {
                    self.center = self.initialCenter
                    self.transform = .identity
                }
            }
            
        default:
            break
        }
    }
    
    private func animateOffScreen(direction: SwipeDirection) {
        let screenWidth = UIScreen.main.bounds.width
        let destinationX = direction == .right ? screenWidth * 2 : -screenWidth * 2
        
        UIView.animate(withDuration: 0.3) {
            self.center.x = destinationX
        } completion: { [weak self] _ in
            self?.onCardRemoved?(direction)
            self?.removeFromSuperview()
        }
    }
    
    func configure(with user: User) {
        nameLabel.text = "\(user.name), \(user.age)"
        professionLabel.text = user.profession
        imageView.image = user.image
    }
}

enum SwipeDirection {
    case left
    case right
}

struct User {
    let name: String
    let age: Int
    let profession: String
    let image: UIImage
}
