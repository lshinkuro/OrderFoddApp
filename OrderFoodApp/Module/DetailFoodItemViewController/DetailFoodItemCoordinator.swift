//
//  DetailFoodItemCoordinator.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/10/24.
//

import Foundation

import UIKit

// Already implemented from the previous example
class DetailFoodCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let detailVC = DetailFoodItemViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    func start(with foodItem: FoodItem?) {
           let detailVC = DetailFoodItemViewController()
           detailVC.foodItem = foodItem
           detailVC.hidesBottomBarWhenPushed = true
           navigationController?.pushViewController(detailVC, animated: true)
    }
}
