//
//  PopUpLaoding.swift
//  OrderFoodApp
//
//  Created by Phincon on 22/10/24.
//

import UIKit
import Lottie
import SnapKit

/// Can be used as loading indicator while fetching data on BE.
/// Sample use is at the end of this class
/// - Initialize this class with `UIView` on which it will appear on
/// - call function `show()` to show the loading animation.
/// - call function `dismiss()` to dismiss the loading animation and remove it from `superView`.
class PopUpLoading {
    
    private let widthHeight: CGFloat = 104
    private var parentView: UIView
    private var animationView = LottieAnimationView(name: "loading_food")
    private var backgroundCover: UIView
    private let common = Common.shared
    var customBackgroundColor: UIColor = UIColor()
    
    init(on view: UIView) {
        self.parentView = view
        animationView.alpha = 0.3
        animationView.isHidden = true
        self.backgroundCover = UIView()
        self.backgroundCover.backgroundColor = .clear
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
    }
    
    private func animateView() {
        animationView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIViewPropertyAnimator(
            duration: 0.3,
            dampingRatio: 0.6) { [weak self] () in
                guard let self = self else { return }
                self.animationView.isHidden = false
                self.animationView.alpha = 1
                self.animationView.transform = .identity
            } .startAnimation()
    }
    
    func show() {
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAnimation), name: UIScene.willEnterForegroundNotification, object: nil)
        backgroundCover.backgroundColor = UIColor(hex: "#000000").withAlphaComponent(0.3)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        parentView.addSubview(backgroundCover)
        backgroundCover.addSubview(animationView)
        if let header = parentView.viewWithTag(ConstantsTags.ViewTags.roundedHeader) {
            parentView.bringSubviewToFront(header)
        }
        backgroundCover.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.width.equalTo(widthHeight)
            $0.height.equalTo(widthHeight)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        animateView()
    }
    
    func showWithCustomBackgroundColor() {
        backgroundCover.backgroundColor = customBackgroundColor
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        parentView.addSubview(backgroundCover)
        if let header = parentView.viewWithTag(ConstantsTags.ViewTags.roundedHeader) {
            parentView.bringSubviewToFront(header)
        }
        backgroundCover.addSubview(animationView)
        
        backgroundCover.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.width.equalTo(widthHeight)
            $0.height.equalTo(widthHeight)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        animateView()
    }
    
    func showInFull() {
        backgroundCover.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        common.addViewToWindow { window in
            window.addSubview(backgroundCover)
            backgroundCover.tag = ConstantsTags.ViewTags.grayArea
            backgroundCover.addSubview(animationView)
   
            animationView.snp.makeConstraints {
                $0.width.height.equalTo(widthHeight)
                $0.centerX.equalTo(window.snp.centerX)
                $0.centerY.equalTo(window.snp.centerY)
            }
            animateView()
        }
    }
    
    func dismissAfter1() {
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] () in
            guard let self = self else { return }
            self.animationView.removeFromSuperview()
            self.backgroundCover.removeFromSuperview()
            self.animationView.stop()
        }
    }
    
    func dismissImmediately() {
        NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        DispatchQueue.main.async { [weak self] () in
            guard let self = self else { return }
            self.animationView.removeFromSuperview()
            self.backgroundCover.removeFromSuperview()
            self.animationView.stop()
        }
    }
    
    @objc func reloadAnimation() {
        animationView.play()
    }
}

/*
 Sample Use:
 lazy var loadingIndicator = PopUpLoading(on: view)
 
 loadingIndicator.show()
 loadingIndicator.dismiss()
 */
