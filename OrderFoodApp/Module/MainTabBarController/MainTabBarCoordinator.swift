//
//  MainTabBarCoordinator.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/10/24.
//

import Foundation
import UIKit

class MainTabBarCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var tabBarController: MainTabBarController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        tabBarController = MainTabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        
        // Initialize each tab's coordinator
        let dashboardCoordinator = DashboardCoordinator(navigationController: UINavigationController())
        let chartCoordinator = ChartCoordinator(navigationController: UINavigationController())
        let middleCoordinator = Example3DCoordinator(navigationController: UINavigationController())
        let historyCoordinator = HistoryCoordinator(navigationController: UINavigationController())
        let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        
        
        // Configure tab bar items
        dashboardCoordinator.navigationController?.tabBarItem = UITabBarItem(
            title: "Home",
            image: SFSymbols.dashboardSymbol,
            tag: 0
        )
        
        chartCoordinator.navigationController?.tabBarItem = UITabBarItem(
            title: "Chart",
            image: SFSymbols.chartSymbol,
            tag: 1
        )
        
        historyCoordinator.navigationController?.tabBarItem = UITabBarItem(
            title: "History",
            image: SFSymbols.historySymbol,
            tag: 2
        )
        
        profileCoordinator.navigationController?.tabBarItem = UITabBarItem(
            title: "Profile",
            image:SFSymbols.profileSymbol,
            tag: 3
        )
        
        // Start each coordinator to set up the initial view controller
        dashboardCoordinator.start()
        chartCoordinator.start()
        middleCoordinator.start()
        historyCoordinator.start()
        profileCoordinator.start()
        
        guard let dashboardNav = dashboardCoordinator.navigationController,
              let chartNav = chartCoordinator.navigationController,
              let middleNav = middleCoordinator.navigationController,
              let historyNav = historyCoordinator.navigationController,
              let profileNav = profileCoordinator.navigationController else {
            print("Error: Some navigation controllers are missing")
            return
        }
        
        // Set viewControllers
        tabBarController.viewControllers = [
            dashboardNav,
            chartNav,
            middleNav,
            historyNav,
            profileNav
        ]
        
        tabBarController.btnMiddle.addTarget(self, action: #selector(didTapMiddleButton), for: .touchUpInside)
        
        // Configure tab bar appearance
        tabBarController.tabBar.tintColor = UIColor(hex: "#F9881F")
        tabBarController.tabBar.unselectedItemTintColor = .gray
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(hex: "#F9881F")]
            
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    @objc func didTapMiddleButton() {
        // Navigate to TodoListViewController when middle button is tapped
        let todoListVC = TodoListViewController()
        tabBarController.navigationController?.pushViewController(todoListVC, animated: true)
    }
}

