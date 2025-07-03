//
//  TooltipManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/11/24.
//

import Foundation
import UIKit
import SnapKit

class TooltipManager {
    static let shared = TooltipManager()
    private var currentTooltip: TooltipView?
    private weak var parentViewController: UIViewController?
    
    private init() {}
    
    func showTooltip(text: String,
                     near view: UIView,
                     in viewController: UIViewController,
                     position: TooltipPosition = .bottom,
                     trianglePosition: TrianglePosition = .center) {
        // Remove existing tooltip if any
        currentTooltip?.removeFromSuperview()
        
        let tooltip = TooltipView()
        tooltip.configure(
            with: text,
            tooltipPosition: position,
            trianglePosition: trianglePosition
        )
        viewController.view.addSubview(tooltip)
        self.currentTooltip = tooltip
        self.parentViewController = viewController
        
        // Position tooltip relative to view
        tooltip.snp.makeConstraints { make in
            if position == .top {
                make.bottom.equalTo(view.snp.top).offset(-10)
            } else {
                make.top.equalTo(view.snp.bottom).offset(10)
            }
            if trianglePosition == .left {
                make.leading.equalTo(view.snp.leading).offset(10)
            } else if trianglePosition == .center {
                make.centerX.equalTo(view)
            } else if trianglePosition == .right {
                make.trailing.equalTo(view.snp.trailing)
            }
            make.width.lessThanOrEqualTo(viewController.view.snp.width).multipliedBy(0.8)
        }
        
        // Animation
        tooltip.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        tooltip.alpha = 0
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            tooltip.transform = .identity
            tooltip.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            self?.hideTooltip()
        }
    }
    
    private func hideTooltip() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.currentTooltip?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.currentTooltip?.alpha = 0
        } completion: { _ in
            self.currentTooltip?.removeFromSuperview()
            self.currentTooltip = nil
            self.parentViewController = nil
        }
    }
}
