//
//  FilterPinCollectionViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/11/24.
//

import Foundation
import SnapKit
import UIKit

// MARK: - FilterCell
final class FilterCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 16 // Increased corner radius for pill shape
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
    }
    
    func configure(with title: String, isSelected: Bool) {
       titleLabel.text = title
       
       UIView.animate(withDuration: 0.2) {
           self.contentView.backgroundColor = isSelected ? .systemBlue : .systemBackground
           self.contentView.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.systemGray3.cgColor
           self.titleLabel.textColor = isSelected ? .white : .black
       }
   }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
           let attrs = super.preferredLayoutAttributesFitting(layoutAttributes)
           _ = CGSize(width: layoutAttributes.frame.width, height: 36)
           
           // Calculate width based on text content, using CGFloat.greatestFiniteMagnitude
           let size = titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 36))
           attrs.frame.size = CGSize(width: size.width + 32, height: 36)
           
           return attrs
       }
}

// MARK: - Custom Flow Layout
class PinFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        minimumInteritemSpacing = 8
        minimumLineSpacing = 8
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        
        let attributes = originalAttributes.map { attribute in
            let copyAttribute = attribute.copy() as! UICollectionViewLayoutAttributes
            
            if attribute.representedElementCategory == .cell {
                if copyAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                
                copyAttribute.frame.origin.x = leftMargin
                leftMargin += copyAttribute.frame.width + minimumInteritemSpacing
                maxY = max(copyAttribute.frame.maxY, maxY)
            }
            
            return copyAttribute
        }
        
        return attributes
    }
}
