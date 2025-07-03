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
    
    lazy var emptyStateView = EmptyStateView(frame: tableView.frame)
    private var cartItems: [(food: FoodItem, quantity: Int)] = []
    let viewModel = ChartViewModel()
    
    var orderItems: [OrderItem] {
        return cartItems.map { item in
            OrderItem(
                id: 3,
                name: "Pizza",
                price: 100000,
                quantity: item.quantity
            )
        }
    }
    
    var total: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindData()
    }
    
    func bindData() {
        viewModel.orderModel
            .asObservable()
            .subscribe(onNext: { [weak self] dataItem in
                guard let self = self else { return }
                guard let dataItem = dataItem else { return }
                DispatchQueue.main.async {
                    let token = dataItem.transaction.token
                    
                    let vc = MidtransViewController()
                    vc.token = token
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }).disposed(by: disposeBag)
        
        viewModel.loadingState.asObservable().subscribe(onNext: { loading in
//            guard let self = self else { return }
            DispatchQueue.main.async {
                switch loading {
                case .loading:
                    print("loading")
                case .failed:
                    print("gagal request")
                case .finished:
                    print("selesai request")
                default:
                    break
                }
            }
            
        }).disposed(by: disposeBag)
        
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
        createOrder()
//        showCustomPIN {
//            print("test")
//        }
    }
    
    private func loadCartItems() {
        cartItems = CartService.shared.getCartItems()
        emptyStateView.delegate = self
        updateTotalPrice()
        updateEmptyStateView()
        tableView.reloadData()
    }
    
    
    private func updateTotalPrice() {
        total = cartItems.reduce(0) { $0 + $1.food.price * Double($1.quantity) }
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
    
    
    func createOrder() {
        let orderParam = CreateOrderParam(email: "test@gmail.com",
                                          items: [OrderItem(
                                            id: 3,
                                            name: "Pizza",
                                            price: 100000,
                                            quantity: 1
                                        )],
                                          amount: 100000)
        viewModel.createOrder(param: orderParam)
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

