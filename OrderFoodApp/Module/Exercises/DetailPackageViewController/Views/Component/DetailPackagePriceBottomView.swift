//
//  DetailPackagePriceBottomView.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import Foundation
import UIKit
import SnapKit

class DetailPackagePriceBottomView: UIView {
    
    // MARK: - Properties
    private var isExpanded = false
    private var itemViews = [UIView]()
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ringkasan Pembayaran"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        return view
    }()
    
    private let totalPriceContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Harga Total"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let totalPriceValue: UILabel = {
        let label = UILabel()
        label.text = "Rp50.000"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.down")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let buyNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Beli Sekarang", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "calendar")
        button.setImage(image, for: .normal)
        button.tintColor = .systemRed
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupData()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        addSubview(titleLabel)
        addSubview(separatorLine)
        addSubview(totalPriceContainer)
        totalPriceContainer.addSubview(totalPriceLabel)
        totalPriceContainer.addSubview(totalPriceValue)
        totalPriceContainer.addSubview(arrowButton)
        addSubview(buyNowButton)
        addSubview(calendarButton)
    }
    
    private func setupData() {
        // Item 1: Internet Package
        addItemRow(title: "Internet OMG! 20 GB", price: "Rp50.000")
        
        // Item 2: Add on 1
        addItemRow(title: "Add on 1", price: "Rp10.000")
        
        // Item 3: Add on 2
        addItemRow(title: "Add on 2", price: "Rp10.000")
        
        // Item 4: Add on 3
        addItemRow(title: "Add on 3", price: "Rp10.000")
        
        // Item 5: Discount
        addItemRow(title: "Diskon", price: "-Rp1.000", isDiscount: true)
    }
    
    private func addItemRow(title: String, price: String, isDiscount: Bool = false) {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        let priceLabel = UILabel()
        priceLabel.text = price
        priceLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        if isDiscount {
            priceLabel.textColor = .systemGreen
        }
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(priceLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        addSubview(containerView)
        itemViews.append(containerView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        // Setup item views constraints
        var previousView: UIView = titleLabel
        for (index, itemView) in itemViews.enumerated() {
            itemView.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(20)
            }
            previousView = itemView
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(1)
        }
        
        totalPriceContainer.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(30)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
        }
        
        arrowButton.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        totalPriceValue.snp.makeConstraints { make in
            make.right.equalTo(arrowButton.snp.left).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        calendarButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(totalPriceContainer.snp.bottom).offset(20)
            make.width.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        buyNowButton.snp.makeConstraints { make in
            make.left.equalTo(calendarButton.snp.right).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(calendarButton)
            make.height.equalTo(50)
        }
        
        showExpandedView()
    }
    
    private func setupActions() {
        arrowButton.addTarget(self, action: #selector(toggleDetails), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func toggleDetails() {
        isExpanded = !isExpanded
        showExpandedView()
    }
    
    func showExpandedView() {
        // Rotate the arrow
        UIView.animate(withDuration: 0.3) {
            self.arrowButton.transform = self.isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
        }
        
        titleLabel.isHidden = !isExpanded
        // Hide/Show item views
        for itemView in itemViews {
            itemView.isHidden = !isExpanded
            separatorLine.isHidden = !isExpanded
        }
        
        // Update constraints for collapsed state
        if !isExpanded {
//            separatorLine.snp.remakeConstraints { make in
//                make.top.equalToSuperview().offset(20) // Connect directly to top when collapsed
//                make.left.equalToSuperview().offset(16)
//                make.right.equalToSuperview().offset(-16)
//                make.height.equalTo(1)
//            }
            
            totalPriceContainer.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(30)
            }
        } else {
            // Restore original constraints
//            separatorLine.snp.remakeConstraints { make in
//                make.top.equalTo(itemViews.last!.snp.bottom).offset(20)
//                make.left.equalToSuperview().offset(16)
//                make.right.equalToSuperview().offset(-16)
//                make.height.equalTo(1)
//            }
            
            totalPriceContainer.snp.remakeConstraints { make in
                make.top.equalTo(separatorLine.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(30)
            }
        }
        
        self.layoutIfNeeded()    }
}
