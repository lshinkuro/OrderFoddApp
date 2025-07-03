//
//  PurchaseOptionCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import UIKit
import SnapKit

class PurchaseOptionCell: UITableViewCell {
    
    static let reuseIdentifier = "PurchaseOptionCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.drawDottedBorder()
        return view
    }()
    
    private let stackView = UIStackView().configure {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    private let oneTimePurchaseView = PurchaseOptionView(
        title: "Beli Sekali",
        subtitle: "Tanpa langganan. Beli kapan pun dibutuhkan."
    )
    
    private let autoRenewalView = PurchaseOptionView(
        title: "Perpanjang Otomatis",
        subtitle: "Diperbarui otomatis setiap 1 bulan. Maksimum 24 bulan. Batalkan kapan saja."
    )
    
    var onOptionSelected: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    private func setupView() {
        selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        stackView.addStack(oneTimePurchaseView, autoRenewalView)
        
        containerView.addSubview(stackView)
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    private func setupActions() {
        oneTimePurchaseView.onSelect = { [weak self] in
            self?.updateSelection(selectedIndex: 0)
        }
        
        autoRenewalView.onSelect = { [weak self] in
            self?.updateSelection(selectedIndex: 1)
        }
    }
    
    private func updateSelection(selectedIndex: Int) {
        oneTimePurchaseView.isSelectedOption = selectedIndex == 0
        autoRenewalView.isSelectedOption = selectedIndex == 1
        
        onOptionSelected?(selectedIndex)
    }
}

