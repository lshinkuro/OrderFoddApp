//
//  CustomLayoutCollectionView.swift
//  OrderFoodApp
//
//  Created by Phincon on 02/10/24.
//

import Foundation
import UIKit

class CustomLayoutCollection: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 15
        self.minimumInteritemSpacing = 10
    }
    
}

