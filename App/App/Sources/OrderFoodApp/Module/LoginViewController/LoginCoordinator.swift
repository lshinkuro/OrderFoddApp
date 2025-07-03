//
//  LoginCoordinator.swift
//  OrderFoodApp
//
//  Created by Phincon on 29/10/24.
//

import Foundation
import UIKit

// Already implemented from the previous example
class LoginCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func showHomeScreen() {
        // Navigate to home screen
        AppSettings.shared.isFirstTime = false
//        let tabbar = MainTabBarController()
//        self.navigationController?.pushViewController(tabbar, animated: true)
        
        guard let navigationController = navigationController else { return }
        let mainCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        mainCoordinator.start()
    }
    
    func showRegister() {
        guard let navigationController = navigationController else {
            return
        }
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.start()
    }
}
