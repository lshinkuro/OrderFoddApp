//
//  DashboardCoordinator.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/10/24.
//

import Foundation
import UIKit


// Already implemented from the previous example
class DashboardCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let dashboardVC = DashboardViewController()
        dashboardVC.coordinator = self
        navigationController?.viewControllers = [dashboardVC]
    }
    
    
    func showDetail(with foodItem: FoodItem?) {
        guard let navigationController = navigationController else {
            return
        }
        let detailCoordinator = DetailFoodCoordinator(navigationController: navigationController)
        detailCoordinator.start(with: foodItem)
    }
}
