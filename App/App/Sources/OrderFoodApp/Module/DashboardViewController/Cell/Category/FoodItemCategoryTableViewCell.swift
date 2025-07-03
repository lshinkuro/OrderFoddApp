//
//  FoodItemCategoryTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import UIKit
import SkeletonView

class FoodItemCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var categoryItems: [FoodCategoryData] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var onSelectCategory: ((_ category: FoodCategory) -> Void)?

    var selectedIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        
        // Register the cell's XIB file with the collection view
        let nib = UINib(nibName: "FoodItemCategoryCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "FoodItemCategoryCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension FoodItemCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    // UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodItemCategoryCollectionViewCell", for: indexPath) as?  FoodItemCategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        
        cell.configureData(item: categoryItems[indexPath.row].category)
        
        // Configure the cell based on the selection
        if indexPath == selectedIndexPath {
            cell.containerView.layer.borderWidth = 1.0
            cell.containerView.layer.borderColor = UIColor(hex: "#3EC032").cgColor
            cell.subContainerView.backgroundColor =  UIColor(hex: "#F0CCC1")
        } else {
            cell.containerView.layer.borderWidth = 0.0
            cell.subContainerView.backgroundColor = UIColor(hex: "#A9E88B").withAlphaComponent(0.1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: (screenWidth / 3) - 40 , height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categoryItems[indexPath.row].category
        onSelectCategory?(selectedCategory)
        
        // Deselect the previous cell
        if let previousIndexPath = selectedIndexPath {
            let previousCell = collectionView.cellForItem(at: previousIndexPath) as? FoodItemCategoryCollectionViewCell
            previousCell?.contentView.backgroundColor = .clear // Reset previous cell color
        }
        selectedIndexPath = indexPath
    }
}


extension FoodItemCategoryTableViewCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return default count of skeleton cells
        return 10
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        // Return the identifier for the skeleton cell
        return "FoodItemCategoryCollectionViewCell"
    }
}
