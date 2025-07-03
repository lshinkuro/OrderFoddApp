//
//  ExpensesCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/11/24.
//

import Foundation
import UIKit
import SnapKit

class ExpensesCell: UICollectionViewCell {
    static let reuseIdentifier = "ExpensesCell"
    
    private let expenseLabel = UILabel()
    private let incomeLabel = UILabel()
    private let expenseValueLabel = UILabel()
    private let incomeValueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [expenseLabel, incomeLabel, expenseValueLabel, incomeValueLabel].forEach {
            contentView.addSubview($0)
        }
        
        expenseLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        expenseValueLabel.snp.makeConstraints { make in
            make.top.equalTo(expenseLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }
        
        incomeLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
        
        incomeValueLabel.snp.makeConstraints { make in
            make.top.equalTo(incomeLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(with data: ExpensesModel) {
        expenseValueLabel.text = "$\(data.expense)"
        incomeValueLabel.text = "$\(data.income)"
    }
}
