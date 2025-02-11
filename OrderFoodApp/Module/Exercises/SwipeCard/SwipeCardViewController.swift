//
//  SwipeCardViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/11/24.
//

import UIKit
import SnapKit

class SwipeCardViewController: UIViewController {
    
    private var users: [User] = []
    private var currentCardIndex = 0
    private var visibleCards: [CardView] = []
    private let maxVisibleCards = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupMockData()
        setupInitialCards()
    }
    
    private func setupMockData() {
        // Add your mock users here
        users = [
            User(name: "Ayu", age: 28, profession: "Designer", image: UIImage(named: "cewe1")!),
            User(name: "Sarah", age: 25, profession: "Engineer", image: UIImage(named: "cewe2")!),
            User(name: "Bella", age: 30, profession: "Doctor", image: UIImage(named: "cewe3")!),
            User(name: "Emma", age: 27, profession: "Artist", image: UIImage(named: "cewe4")!),
            User(name: "Risa", age: 29, profession: "Teacher", image: UIImage(named: "cewe5")!),
            User(name: "Maya", age: 29, profession: "Teacher", image: UIImage(named: "cewe6")!),
            User(name: "Vina", age: 29, profession: "Teacher", image: UIImage(named: "cewe7")!),
            User(name: "Rossa", age: 29, profession: "Teacher", image: UIImage(named: "cewe8")!)

        ]
    }
    
    private func setupInitialCards() {
        // Show first few cards
        for i in 0..<min(maxVisibleCards, users.count) {
            addCard(at: i)
        }
    }
    
    private func addCard(at index: Int) {
        guard index < users.count else { return }
        
        let cardView = CardView(frame: CGRect(x: 0, y: 0, width: 340, height: 480))
        view.addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(340)
            make.height.equalTo(480)
        }
        
        // Configure card with user data
        cardView.configure(with: users[index])
        
        // Set up card removal callback
        cardView.onCardRemoved = { [weak self] direction in
            self?.handleCardRemoved(direction: direction)
        }
        
        // Add scaling effect for stack appearance
        let scale = getScaleForCardAt(index: visibleCards.count)
        cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
                                             .translatedBy(x: 0, y: CGFloat(visibleCards.count * 8))
        
        visibleCards.append(cardView)
    }
    
    private func handleCardRemoved(direction: SwipeDirection) {
        // Remove the top card from our array
        visibleCards.removeFirst()
        currentCardIndex += 1
        
        // Animate remaining cards up
        animateRemaining()
        
        // Add a new card if there are more users
        if currentCardIndex + maxVisibleCards - 1 < users.count {
            addCard(at: currentCardIndex + maxVisibleCards - 1)
        }
        
        // Check if we've run out of cards
        if visibleCards.isEmpty {
            handleNoMoreCards()
        }
    }
    
    private func animateRemaining() {
        for (index, card) in visibleCards.enumerated() {
            UIView.animate(withDuration: 0.2) {
                let scale = self.getScaleForCardAt(index: index)
                card.transform = CGAffineTransform(scaleX: scale, y: scale)
                                                 .translatedBy(x: 0, y: CGFloat(index * 8))
            }
        }
    }
    
    private func getScaleForCardAt(index: Int) -> CGFloat {
        let scale = 1.0 - (CGFloat(index) * 0.05)
        return max(scale, 0.9)
    }
    
    private func handleNoMoreCards() {
        // Show "No more profiles" message or refresh
        let label = UILabel()
        label.text = "No more profiles available!"
        label.textColor = .red
        label.textAlignment = .center
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
}

