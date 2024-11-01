//
//  OnBoardingCoordinator.swift
//  OrderFoodApp
//
//  Created by Phincon on 29/10/24.
//

import Foundation
import UIKit


class OnboardingCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let navigationController = navigationController else {
            print("Error: No navigation controller available")
            return
        }
        let onboardVC = OnBoardingViewController()
        onboardVC.coordinator = self
        navigationController.pushViewController(onboardVC, animated: true)
    }
    
    
    func showLogin() {
        guard let navigationController = navigationController else {
            // Handle nil navigation controller scenario
            print("Error: No navigation controller available")
            return
        }
        
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
    }
    
}
