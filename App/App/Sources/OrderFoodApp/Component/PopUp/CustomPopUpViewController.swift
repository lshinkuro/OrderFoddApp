//
//  CustomPopUpViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 03/10/24.
//

import UIKit




struct PopUpModel {
    var title: String
    var description: String
    var image: String
    var twoButton: Bool = false
}

class CustomPopUpViewController: UIViewController {
    
    @IBOutlet weak var coachmarkView: UIView!
    @IBOutlet weak var containerView: FormView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popupImage: UIImageView!
    
    var popUpData: PopUpModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerInitialState(containerView)
        animateContainerUp(containerView)
        configureData()
    }
    
    
    func configure() {
        okBtn.addTarget(self, action: #selector(tapBtn), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        coachmarkView.addGestureRecognizer(tapGesture)
    }
    
    
    func configureData() {
        if let data = popUpData {
            popupImage.image = UIImage(named: data.image)
            titleLabel.text = data.title
            descriptionLabel.text = data.description
            cancelButton.isHidden = !data.twoButton
        }
    }
    
 

    func setup() {
        coachmarkView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc func tapBtn() {
        self.dismiss(animated: true)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismissPopup(backView: coachmarkView, contentView: containerView)
    }

}

extension CustomPopUpViewController  {

    func containerInitialState(_ view: UIView) {
        view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
    }

    func animateContainerUp(_ view: UIView) {
        let animation = UIViewPropertyAnimator(
            duration: 0.5,
            dampingRatio: 0.8) { () in
            view.transform = .identity
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
}

