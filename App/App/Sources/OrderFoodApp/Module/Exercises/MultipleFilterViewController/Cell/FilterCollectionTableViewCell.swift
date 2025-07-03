//
//  FilterCollectionTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 17/11/24.
//

import Foundation
import UIKit
import SnapKit

// MARK: - CollectionTableViewCell
final class CollectionTableViewCell: UITableViewCell {
    
    private lazy var collectionView: UICollectionView = {
        let layout = PinFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        layout.estimatedItemSize = CGSize(width: 100, height: 36) // Add estimated size
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        collection.isScrollEnabled = false // Disable scrolling
        return collection
    }()
    
    
    private var filters: [FilterModel] = []
    private var selectedItems: Set<String> = []
    private var itemSelected: ((String, Bool) -> Void)?
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with filters: [FilterModel], selectedItems: Set<String>, itemSelected: @escaping (String, Bool) -> Void) {
        self.filters = filters
        self.selectedItems = selectedItems
        self.itemSelected = itemSelected
        collectionView.reloadData()
        
        // Force layout update
        collectionView.layoutIfNeeded()
        
        // Update cell height based on content
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        self.contentView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
    }
}

// MARK: - CollectionView DataSource & Delegate
extension CollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }
        
        let filter = filters[indexPath.item]
        cell.configure(with: filter.title, isSelected: selectedItems.contains(filter.title))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filters[indexPath.item]
        let newIsSelected = !selectedItems.contains(filter.title)
        itemSelected?(filter.title, newIsSelected)
        
        // Update local state immediately
        if newIsSelected {
            selectedItems.insert(filter.title)
        } else {
            selectedItems.remove(filter.title)
        }
        
        // Reload just this cell with animation
        UIView.animate(withDuration: 0.2) {
            if let cell = collectionView.cellForItem(at: indexPath) as? FilterCell {
                cell.configure(with: filter.title, isSelected: newIsSelected)
            }
        }
    }
}
