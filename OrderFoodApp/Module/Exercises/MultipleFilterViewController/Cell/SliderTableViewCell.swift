//
//  SliderTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/11/24.
//

import Foundation
import UIKit
import SnapKit

// MARK: - SliderTableViewCell
final class SliderTableViewCell: UITableViewCell {
    private var valueChanged: ((Float) -> Void)?
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(slider)
        
        slider.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(minValue: Float, maxValue: Float, currentValue: Float, valueChanged: @escaping (Float) -> Void) {
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.value = currentValue
        self.valueChanged = valueChanged
    }
    
    @objc private func sliderValueChanged() {
        valueChanged?(slider.value)
    }
}
