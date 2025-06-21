//
//  AddonsContentView.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import UIKit
import SnapKit

// MARK: - Custom Add-On Content View
class AddOnContentView: UIView {
    
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill // Pastikan title tidak terjepit oleh value
        return stackView
    }()
    
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
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.drawDottedBorder()
        return view
    }()
    
    init(with item: AddOnItem) {
        super.init(frame: .zero)
        // Critical: Set up all the UI components first
        setupViews()
        self.bind(with: item)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Views
    private func setupViews() {
        // Add subviews
        addSubview(stackView)
        stackView.addArrangedSubview(bestValueBadge)
        bestValueBadge.addSubview(bestValueLabel)
        add(titleLabel, dataLabel, durationLabel, descriptionLabel, detailButton, originalPriceLabel, currentPriceLabel, selectionCheckBox,separatorView)
        
        // Update constraints for stackView
        stackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(100) // Lebar stackView tetap 100
            // Hapus constraint tinggi tetap
            
            // Tambahkan kondisi agar stackView tidak menjadi height = 0
            make.height.greaterThanOrEqualTo(24).priority(.low)
        }
        
        bestValueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.remakeConstraints { make in
            if stackView.isHidden {
                make.top.equalToSuperview().offset(8) // Jika bestValueBadge tidak ada
            } else {
                make.top.equalTo(stackView.snp.bottom).offset(8) // Jika ada bestValueBadge
            }
            make.leading.equalToSuperview()
            make.trailing.equalTo(originalPriceLabel.snp.leading).offset(-8)
        }
        
        dataLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(dataLabel.snp.trailing)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dataLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalTo(selectionCheckBox.snp.leading)
        }
        
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(detailButton.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        originalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        currentPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(originalPriceLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        selectionCheckBox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    // MARK: Bind Data
    func bind(with item: AddOnItem) {
        titleLabel.text = item.title
        dataLabel.text = item.data
        durationLabel.text = item.duration
        descriptionLabel.text = item.description
        originalPriceLabel.text = item.originalPrice
        currentPriceLabel.text = item.currentPrice
        selectionCheckBox.isSelected = item.isSelected
        // Sesuaikan visibilitas stackView
        stackView.isHidden = !item.hasBestValueBadge
        
        // Update constraint titleLabel
        titleLabel.snp.remakeConstraints { make in
            if item.hasBestValueBadge {
                make.top.equalTo(stackView.snp.bottom).offset(8)
            } else {
                make.top.equalToSuperview().offset(8)
            }
            make.leading.equalToSuperview()
            make.trailing.equalTo(originalPriceLabel.snp.leading).offset(-8)
        }
        layoutIfNeeded() // Pastikan perubahan layout langsung diterapkan
    }
}
