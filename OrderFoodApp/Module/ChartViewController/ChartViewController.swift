//
//  ChartViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 30/09/24.
//

import UIKit

class ChartViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalPriceStackView: UIStackView!
    @IBOutlet weak var paymentButton: GradientColorButton!
    
    private var cartItems: [(food: FoodItem, quantity: Int)] = []
    lazy var emptyStateView = EmptyStateView(frame: tableView.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCartItems()
        hideNavigationBar()
    }
    
    
    func hideNavigationBar(){
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = true
        self.hidesBottomBarWhenPushed = false
    }
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "FoodChartItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FoodChartItemTableViewCell")
        
        paymentButton.addTarget(self, action: #selector(actionCheckout), for: .touchUpInside)
    }
    
    @objc func actionCheckout() {
        showCustomPIN {
            print("test")
        }
    }
    
    private func loadCartItems() {
        cartItems = CartService.shared.getCartItems()
        emptyStateView.delegate = self
        updateTotalPrice()
        updateEmptyStateView()
        tableView.reloadData()
    }
    
    private func updateTotalPrice() {
        let total = cartItems.reduce(0) { $0 + $1.food.price * Double($1.quantity) }
        totalPriceLabel.text = "Rp \(String(total).convertToCurrencyWithDecimal())"
        updateEmptyStateView()
    }
    
    private func updateEmptyStateView() {
        shouldShowErrorView(status: cartItems.isEmpty)
        [tableView, totalPriceStackView, paymentButton].forEach { $0?.isHidden = cartItems.isEmpty }
    }
    
    func shouldShowErrorView(status: Bool) {
        switch status {
        case true:
            if !view.subviews.contains(emptyStateView) {
                view.addSubview(emptyStateView)
            } else {
                emptyStateView.isHidden = false
            }
        case false:
            if view.subviews.contains(emptyStateView) {
                emptyStateView.isHidden = true
            }
        }
    }
    
    
    
}


extension ChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodChartItemTableViewCell", for: indexPath) as? FoodChartItemTableViewCell else {
            return UITableViewCell()
        }
        let item = cartItems[indexPath.row] //(food: FoodItem, quantity: Int)
        cell.configure(with: item.food, quantity: item.quantity)
        cell.delegate = self
        return cell
    }
    
    
}

extension ChartViewController: FoodChartItemTableViewCellDelegate {
    func cartItemCell(didTapAddFor food: FoodItem) {
        CartService.shared.addToCart(food: food)
        loadCartItems()
    }
    
    func cartItemCell(didTapRemoveFor food: FoodItem) {
        CartService.shared.removeFromCart(food: food)
        loadCartItems()
    }
    
}

extension ChartViewController: EmptyStateViewDelegate {
    func tapButton() {
        if let mainTabBarController = self.tabBarController as? MainTabBarController {
            mainTabBarController.switchToTab(type: .dashboard)
        }
    }
}

