//
//  MainTabBarController.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import Foundation
import UIKit

enum MainTabBarType: Int, CaseIterable {
    case dashboard
    case chart
    case middle
    case history
    case profile
}

class MainTabBarController: UITabBarController {
    
    let btnMiddle : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        btn.setTitle("", for: .normal)
        btn.backgroundColor = UIColor(hex: "#F9881F")
        btn.layer.cornerRadius = 30
        btn.layer.shadowColor = UIColor(hex: "#F9881F").cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = UIColor.white
        return btn
    }()
    
    let dashboard = UINavigationController(rootViewController: DashboardViewController())
    let chart = UINavigationController(rootViewController: ChartViewController())
    let middle = UINavigationController(rootViewController: Example3DViewController())
    let history = UINavigationController(rootViewController: HistoryOrderViewController())
    let profile = UINavigationController(rootViewController: ProfileViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureUITabBarItems()
        setupCustomTabBar()
        
    }
    
    override func loadView() {
        super.loadView()
        self.tabBar.addSubview(btnMiddle)
        setupCustomTabBar()
    }
    
    func  configureTabBar(){
        self.setViewControllers([dashboard, chart, middle, history, profile], animated: true)
        btnMiddle.frame = CGRect(x: Int(self.tabBar.bounds.width)/2 - 30, y: -20, width: 60, height: 60)
        btnMiddle.addTarget(self, action: #selector(btnMiddleTapped), for: .touchUpInside)
    }
    
    @objc func btnMiddleTapped() {
        let vc = UINavigationController(rootViewController: TodoListViewController())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureUITabBarItems(){
        dashboard.tabBarItem = UITabBarItem(title: "Home", image: SFSymbols.dashboardSymbol, tag: 0)
        chart.tabBarItem = UITabBarItem(title: "Chart", image:  SFSymbols.chartSymbol, tag: 1)
        history.tabBarItem = UITabBarItem(title: "History", image:  SFSymbols.historySymbol, tag: 2)
        profile.tabBarItem = UITabBarItem(title: "Profile", image:  SFSymbols.profileSymbol, tag: 3)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
        UITabBar.appearance().tintColor = UIColor.magenta
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    func hideNavigationBar() {
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = true
        self.hidesBottomBarWhenPushed = false
    }
    
}

extension MainTabBarController {
    func switchToTab(type: MainTabBarType) {
        self.selectedIndex = type.rawValue
        
        switch  type {
        case .dashboard:
            if let dashboardVC = self.viewControllers?[0] as? DashboardViewController {
                self.selectedViewController = dashboardVC
            }
        case .chart:
            if let VC = self.viewControllers?[1] as? ChartViewController {
                self.selectedViewController = VC
            }
        case .middle:
            if let VC = self.viewControllers?[2] as? TodoListViewController {
                self.selectedViewController = VC
            }
        case .history:
            if let VC = self.viewControllers?[3] as? HistoryOrderViewController {
                self.selectedViewController = VC
            }
        case .profile:
            if let VC = self.viewControllers?[4] as? ProfileViewController {
                self.selectedViewController = VC
            }
        }
    }
}

extension MainTabBarController {
    func setupCustomTabBar() {
        let path: UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor.foodWhite100.cgColor
        shape.fillColor = UIColor.foodWhite100.cgColor
        self.tabBar.layer.insertSublayer(shape, at: 0)
        self.tabBar.itemWidth = 40
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 70
        self.tabBar.tintColor = UIColor(hex: "#F9881F")
        self.tabBar.unselectedItemTintColor = UIColor(hex: "#AAACAE")
        self.tabBar.barTintColor = UIColor.clear
        self.tabBar.backgroundColor = UIColor.clear
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
    }
    
    
    
    func getPathForTabBar() -> UIBezierPath {
        let holeWidth: CGFloat = 170
        let holeHeight: CGFloat = btnMiddle.frame.height + 30 // Sesuaikan ketinggian lengkungan agar tidak terlalu menonjol
        let frameWidth = self.tabBar.bounds.width
        let frameHeight = self.tabBar.bounds.height + 40
        let leftXUntilHole = (frameWidth / 2 - holeWidth / 2)
        
        let path = UIBezierPath()
        
        // Move to the starting point
        path.move(to: CGPoint(x: 0, y: 0))
        
        // 1. Line
        path.addLine(to: CGPoint(x: leftXUntilHole, y: 0))
        
        
        // 2. Line
        path.addLine(to: CGPoint(x: frameWidth, y: 0))
        
        // 3. Line
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight))
        
        // 4. Line
        path.addLine(to: CGPoint(x: 0, y: frameHeight))
        
        // 5. Line
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        // Close the path
        path.close()
        
        return path
    }
    
    
}
