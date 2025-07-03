//
//  Example3DCoordinator.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/10/24.
//

import Foundation
import UIKit

// Already implemented from the previous example
class Example3DCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = FeatureListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
