//
//  DetailFoodItemViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import UIKit
import Toast

class DetailFoodItemViewController: UIViewController {
    
    
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var quantityLable: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    
    
    @IBOutlet weak var addToChartButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var foodItem: FoodItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      hideNavigationBar()
    }
    

    func hideNavigationBar(){
      self.navigationController?.isToolbarHidden = true
      self.navigationController?.isNavigationBarHidden = true
      self.navigationController?.navigationBar.isTranslucent = false
      self.navigationController?.isNavigationBarHidden = true
      self.hidesBottomBarWhenPushed = false
    }
    
    func setup() {
        addToChartButton.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
    }
    
    func loadData() {
        if let item = foodItem {
            itemNameLabel.text = item.name
            imgView.image = UIImage(named: item.image)
            descriptionLabel.text = item.description
            ratingLabel.text = String(item.rating)
            priceLabel.text = String(format: "Rp %.2f", item.price)
        }
        
        
    }
    
    @objc func actionTap() {
        if let foodItem = self.foodItem {
            CartService.shared.addToCart(food: foodItem)
            let config = ToastViewConfiguration(subtitleNumberOfLines: 0)
            let toast = Toast.default(
                image: UIImage(named: foodItem.image) ?? UIImage(),
                title: "Berhasil",
                subtitle: "\(foodItem.name) telah ditambahkan ke keranjang",
                viewConfig: config
            )
            toast.show(after: 0.3)
        }
        
    }

}
