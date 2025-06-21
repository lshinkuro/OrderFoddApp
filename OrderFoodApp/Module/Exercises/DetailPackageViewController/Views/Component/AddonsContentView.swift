//
//  AddonsContentView.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Custom Add-On Content View
class AddOnContentView: UIView {
    // MARK: - UI Components
    let bestValueBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 10
        return view
    }()
    
    let bestValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Add-On terbaik!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    let dataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    let detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Lihat Detail", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let selectionCheckBox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        // Add subviews
        addSubview(bestValueBadge)
        bestValueBadge.addSubview(bestValueLabel)
        addSubview(titleLabel)
        addSubview(dataLabel)
        addSubview(durationLabel)
        addSubview(descriptionLabel)
        addSubview(detailButton)
        addSubview(originalPriceLabel)
        addSubview(currentPriceLabel)
        addSubview(selectionCheckBox)
        
        // Setup constraints
        bestValueBadge.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        bestValueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bestValueBadge.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalTo(originalPriceLabel.snp.leading).offset(-8)
        }
        
        dataLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(dataLabel.snp.trailing).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dataLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        
        originalPriceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(selectionCheckBox.snp.leading).offset(-8)
        }
        
        currentPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(originalPriceLabel.snp.bottom).offset(4)
            make.trailing.equalTo(selectionCheckBox.snp.leading).offset(-8)
        }
        
        selectionCheckBox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    // MARK: - Configure View
    func configure(title: String, data: String, duration: String, description: String, originalPrice: String, currentPrice: String, isSelected: Bool, hasBestValueBadge: Bool) {
        titleLabel.text = title
        dataLabel.text = data
        durationLabel.text = duration
        descriptionLabel.text = description
        originalPriceLabel.text = originalPrice
        currentPriceLabel.text = currentPrice
        selectionCheckBox.isSelected = isSelected
        bestValueBadge.isHidden = !hasBestValueBadge
    }
}
