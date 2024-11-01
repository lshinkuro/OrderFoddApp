//
//  LeftMenuSheetViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 04/10/24.
//

import UIKit

class LeftMenuSheetViewController: UIViewController {

    @IBOutlet weak var coachmarkView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerInitialState(containerView)
        animateContainerUp(containerView)
    }
    
    func setup() {
        coachmarkView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc func tapBtn() {
        self.dismiss(animated: true)
    }

   
}


// MARK: for handle animation show
extension LeftMenuSheetViewController  {

    func containerInitialState(_ view: UIView) {
        view.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0) // muncul dari kiri
    }

    func animateContainerUp(_ view: UIView) {
        let animation = UIViewPropertyAnimator(
            duration: 0.5,
            dampingRatio: 1) { () in
            view.transform = .identity
            view.tag = ConstantsTags.ViewTags.container
        }
        animation.startAnimation()
    }

    func animateFadeInBackView(_ view: UIView) {
        view.alpha = 0
        UIView.animate(withDuration: 0.4) {
            view.alpha = 0.6
        }
    }

    func dismissPopup(backView: UIView, contentView: UIView) {
        UIView.animate(withDuration: 0.1) {
            self.coachmarkView.alpha = 0
        }

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut) { [weak self] () in
            guard let self = self else { return }
                self.containerInitialState(self.containerView)
        } completion: { [weak self] isDone in
            guard let self = self else { return }
            if isDone {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismissPopup(backView: coachmarkView, contentView: containerView)
    }

}

// MARK: For handle Gesture
extension LeftMenuSheetViewController {
    
    func configure() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        coachmarkView.addGestureRecognizer(tapGesture)
        coachmarkView.tag = ConstantsTags.ViewTags.grayArea
        
        // New pan gesture on containerView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)
        
        logoutButton.addTarget(self, action: #selector(actionLogout), for: .touchUpInside)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view) // Ambil jarak geser
        let velocity = gesture.velocity(in: view) // Ambil kecepatan geser
        
        switch gesture.state {
        case .changed:
            if translation.x <= 0 { // Pastikan hanya untuk drag ke kekiri
                containerView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            }
        case .ended:
            let dismissThreshold: CGFloat = -100 // Threshold untuk dismiss
            if translation.x < dismissThreshold || velocity.x < -500 { // Jika jarak atau kecepatan cukup
                dismissWithAnimation()
            } else {
                // Kembalikan ke posisi awal jika tidak cukup jauh
                UIView.animate(withDuration: 0.2) {
                    self.containerView.transform = .identity
                }
            }
            
        default:
            break
        }
    }
    
    @objc func actionLogout() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate {
               // Call the logout function
               sceneDelegate.handleLogout()
               FAM.shared.logButtonEvent(buttonName: "Logout", screenName: "LeftMenuSheetViewController")
            }
        self.dismissWithAnimation()
    }
    
    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0) // Geser keluar layar
            self.coachmarkView.alpha = 0 // Fade out gray background
        }) { (completed) in
            if completed {
                self.dismiss(animated: false, completion: nil) // Dismiss setelah animasi selesai
            }
        }
    }
}


