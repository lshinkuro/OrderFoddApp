//
//  CustomTabView.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

//
//  CustomTabView.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import UIKit
import SnapKit

protocol CustomTabViewDelegate: AnyObject {
    func tabSelected(index: Int)
}

class CustomTabView: UIView {
    
    private let titles = ["Detail", "Deskripsi", "S&K"]
    private var buttons: [UIButton] = []
    private let indicatorView = UIView()
    weak var delegate: CustomTabViewDelegate?
    private var selectedIndex = 0
    private let backgroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Background abu-abu dengan corner radius
        backgroundView.backgroundColor = .lightGray
        backgroundView.layer.cornerRadius = 16
        backgroundView.clipsToBounds = true
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        
        backgroundView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Indicator sebagai background button terpilih
        indicatorView.backgroundColor = .darkBlue
        indicatorView.layer.cornerRadius = 16
        backgroundView.addSubview(indicatorView)
        
        for (index, title) in titles.enumerated() {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.tag = index
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            button.backgroundColor = .clear
            
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        
        backgroundView.sendSubviewToBack(indicatorView)
        updateSelectedTab(animated: false)
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        updateSelectedTab(animated: true)
        delegate?.tabSelected(index: selectedIndex)
    }
    
    private func updateSelectedTab(animated: Bool) {
        buttons.forEach { $0.isSelected = false }
        let selectedButton = buttons[selectedIndex]
        selectedButton.isSelected = true
        
        // Pindahkan indicatorView ke button yang terpilih
        indicatorView.snp.remakeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(selectedButton.snp.width)
            make.centerY.equalTo(selectedButton.snp.centerY)
            make.centerX.equalTo(selectedButton.snp.centerX)
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
}

extension UIColor {
    static let darkBlue = UIColor(red: 17/255, green: 34/255, blue: 64/255, alpha: 1)
}
