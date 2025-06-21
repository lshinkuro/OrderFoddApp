//
//  PurchaseOptionView.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import UIKit
import SnapKit

class PurchaseOptionView: UIView {
    
    private let titleLabel = UILabel().configure {
        $0.font = .boldSystemFont(ofSize: 16)

    }
    private let subtitleLabel = UILabel().configure {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.numberOfLines = 0
    }
    private let radioButton = UIButton().configure {
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        $0.tintColor = .darkGray
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    var isSelectedOption: Bool = false {
        didSet {
            updateSelectionState()
        }
    }
    
    var onSelect: (() -> Void)?
    
    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        setupView()
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        backgroundColor = .white
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        radioButton.addTarget(self, action: #selector(didTapOption), for: .touchUpInside)
        
        add(stackView, radioButton)
        
        stackView.addStack(titleLabel, subtitleLabel)
        
        stackView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(12)
            make.trailing.equalTo(radioButton.snp.leading).offset(-10)
        }
        
        radioButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(24)
        }
    }
    
    private func updateSelectionState() {
        radioButton.isSelected = isSelectedOption
        layer.borderColor = isSelectedOption ? UIColor.red.cgColor : UIColor.systemGray4.cgColor
    }
    
    @objc private func didTapOption() {
        onSelect?()
    }
}
