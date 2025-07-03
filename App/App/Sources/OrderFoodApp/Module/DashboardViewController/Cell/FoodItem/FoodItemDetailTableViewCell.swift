//
//  FoodItemDetailTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 01/10/24.
//

import UIKit
import SkeletonView

class FoodItemDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var viewAllLabel: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [FoodItem] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var onSelectItem: ((_ item: FoodItem) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        selectionStyle = .none
        // Register the cell's XIB file with the collection view
        let nib = UINib(nibName: "FoodItemDetailCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "FoodItemDetailCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CustomLayoutCollection()
    }
    
    
}

extension FoodItemDetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    // UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count // Number of items in your collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodItemDetailCollectionViewCell", for: indexPath) as? FoodItemDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setup(data: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: (screenWidth / 2) - 10 , height: 260)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectItem?(items[indexPath.row])
    }
}

extension FoodItemDetailTableViewCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return default count of skeleton cells
        return 10
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        // Return the identifier for the skeleton cell
        return "FoodItemDetailCollectionViewCell"
    }
}

