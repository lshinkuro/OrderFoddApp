//
//  FoodChartItemTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import UIKit

protocol FoodChartItemTableViewCellDelegate: AnyObject {
    func cartItemCell(didTapAddFor food: FoodItem)
    func cartItemCell(didTapRemoveFor food: FoodItem)
}

class FoodChartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var completeLabelImage: UIImageView!
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    weak var delegate: FoodChartItemTableViewCellDelegate?
    private var food: FoodItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minusButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configure(with food: FoodItem, quantity: Int) {
        self.food = food
        titleLabel.text = food.name
        priceLabel.text = String(format: "Rp %.2f", food.price)
        quantityLabel.text = "\(quantity)"

        // Untuk sementara, kita akan menggunakan placeholder image
        itemImg.image = UIImage(named: food.image)
    }
    
    func configureHistory(with food: FoodItem, quantity: Int) {
        self.food = food
        titleLabel.text = food.name
        descLabel.text = "\(quantity) Menu"
        priceLabel.text = String(format: "Rp %.2f", food.price)
        quantityLabel.text = "\(quantity)"

        // Untuk sementara, kita akan menggunakan placeholder image
        itemImg.image = UIImage(named: food.image)
        quantityStackView.isHidden = true
        completeLabelImage.isHidden = false
    }

    @objc private func addButtonTapped() {
        guard let food = food else { return }
        delegate?.cartItemCell(didTapAddFor: food)
    }

    @objc private func removeButtonTapped() {
        guard let food = food else { return }
        delegate?.cartItemCell(didTapRemoveFor: food)
    }
    
    
    
}
