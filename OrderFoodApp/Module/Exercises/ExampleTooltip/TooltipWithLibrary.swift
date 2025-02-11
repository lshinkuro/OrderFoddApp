//
//  TooltipWithLibrary.swift
//  OrderFoodApp
//
//  Created by Phincon on 16/01/25.
//

import Foundation
import UIKit
import EasyTipView

class TooltipWithLibraryViewController: UIViewController {

    private let button = UIButton(type: .system)
    private var tooltip: EasyTipView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupButton()
    }

    private func setupButton() {
        button.setTitle("Tap Me", for: .normal)
        button.addTarget(self, action: #selector(showTooltip), for: .touchUpInside)

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc private func showTooltip() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.backgroundColor = .black
        preferences.drawing.foregroundColor = .white
        preferences.drawing.font = UIFont.systemFont(ofSize: 14)
        preferences.positioning.maxWidth = 200

        tooltip = EasyTipView(text: "This is a tooltip from EasyTipView", preferences: preferences)
        tooltip?.show(forView: button, withinSuperview: view)
    }
}
