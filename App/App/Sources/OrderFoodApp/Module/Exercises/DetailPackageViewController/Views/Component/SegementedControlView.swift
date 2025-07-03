//
//  SegementedControlView.swift
//  OrderFoodApp
//
//  Created by Phincon on 18/03/25.
//

import Foundation
import UIKit


class SegmentedControlView: UIView {
    var onSegmentChanged: ((Int) -> Void)?
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Detail", "Deskripsi", "S&K"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        onSegmentChanged?(segmentedControl.selectedSegmentIndex)

    }
}
