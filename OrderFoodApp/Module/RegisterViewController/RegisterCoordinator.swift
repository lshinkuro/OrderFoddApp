//
//  RegisterCoordinator.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/10/24.
//

import Foundation
import UIKit

// Already implemented from the previous example
class RegisterCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginVC = RegisterViewController()
        loginVC.coordinator = self
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
}
