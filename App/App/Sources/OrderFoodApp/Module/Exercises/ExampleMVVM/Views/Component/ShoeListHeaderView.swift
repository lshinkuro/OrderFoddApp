//
//  ShoeListHeaderView.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/03/25.
//

import Foundation
import UIKit
import SnapKit

class ShoeListHeaderView:UIView {
    
    let containerView:UIView = UIView().configure {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let labelTitle:UILabel = UILabel().configure {
        $0.font = .systemFont(ofSize: 17, weight: .medium)
        $0.textColor = .label
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    let imgView: UIImageView = UIImageView().configure{
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.image = UIImage(systemName: "chevron.right")
    }
    
    var onTapImage: (() -> Void)?
    private var isExpanded = false

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.add(containerView)
        containerView.add(labelTitle, imgView)
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(8)
        }
        
        labelTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(imgView.snp.leading).offset(-8)
        }
        
        imgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        imgView.addTapGestureAction {
            self.handleTapImage()
        }
        
    }
    
    func configure(title: String, isExpanded: Bool = false) {
        labelTitle.text = title
        self.isExpanded = isExpanded
        updateChevronImage()
    }

    private func updateChevronImage() {
        imgView.image = isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.right")
    }
    
    
    func handleTapImage() {
       self.onTapImage?()
    }
    
}

