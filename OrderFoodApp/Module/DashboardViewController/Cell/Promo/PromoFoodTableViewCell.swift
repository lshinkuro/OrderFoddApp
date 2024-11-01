//
//  PromoFoodTableViewCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 02/10/24.
//

import UIKit

class PromoFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataPromo: [PromoFoodData] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        selectionStyle = .none
        collectionView.registerCellWithNib(PromoFoodItemCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = CustomLayoutCollection()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PromoFoodTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataPromo.count // Number of items in your collection view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PromoFoodItemCollectionViewCell
        cell.setup(data: dataPromo[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: (screenWidth) - 100 , height: 84)
    }
    
    
 
}
