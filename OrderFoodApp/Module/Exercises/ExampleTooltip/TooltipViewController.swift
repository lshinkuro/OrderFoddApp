//
//  TooltipViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 16/01/25.
//

import Foundation
import UIKit

class TooltipViewController: UIViewController {

    private let button = UIButton(type: .system)
    private let tooltipView = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupButton()
        setupTooltip()
    }

    private func setupButton() {
        button.setTitle("Tap Me", for: .normal)
        button.addTarget(self, action: #selector(showTooltip), for: .touchUpInside)

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupTooltip() {
        tooltipView.text = "This is a tooltip"
        tooltipView.font = UIFont.systemFont(ofSize: 14)
        tooltipView.textColor = .white
        tooltipView.textAlignment = .center
        tooltipView.backgroundColor = .black
        tooltipView.layer.cornerRadius = 8
        tooltipView.layer.masksToBounds = true
        tooltipView.alpha = 0

        view.addSubview(tooltipView)
    }

    @objc private func showTooltip() {
        let buttonFrame = button.frame
        tooltipView.frame = CGRect(x: buttonFrame.midX - 75, y: buttonFrame.minY - 40, width: 150, height: 30)

        UIView.animate(withDuration: 0.3, animations: {
            self.tooltipView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: [], animations: {
                self.tooltipView.alpha = 0
            }, completion: nil)
        }
    }
}
