//
//  MainCoordinator.swift
//  OrderFoodApp
//
//  Created by Phincon on 29/10/24.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    
    /// Starts the coordinator and defines the initial view controller to present.
    func start()
}


class MainCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var window: UIWindow?

    init(navigationController: UINavigationController?, window: UIWindow?) {
          self.navigationController = navigationController
          self.window = window
      }

    func start() {
        if let tokenData = KeychainHelper.shared.read(forKey: KeychainHelperKey.firebaseAuthToken),
           let _ = String(data: tokenData, encoding: .utf8) {
            showMainTabBar()
        } else {
            showOnboarding()
        }
    }
    
    private func showMainTabBar() {
//        let mainTabBarController = MainTabBarController()
//        mainTabBarController.modalPresentationStyle = .fullScreen
//        navigationController?.setViewControllers([mainTabBarController], animated: true)
        
        guard let navigationController = navigationController else { return }
        let mainCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        mainCoordinator.start()
        
        UINavigationBar.appearance().isHidden = false

    }

    private func showOnboarding() {
        guard let navigationController = navigationController else { return }
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.start()
    }
    
    private func showLogin() {
        guard let navigationController = navigationController else { return }
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
    }
    
    func logout() {
        // Remove Firebase Auth token from Keychain
        KeychainHelper.shared.delete(forKey: "firebaseAuthToken")

        // Navigate to onboarding screen
        let onboardingVC = OnBoardingViewController()
        let onboardingNavigationController = UINavigationController(rootViewController: onboardingVC)
        window?.rootViewController = onboardingNavigationController
    }
}
