//
//  CollectionViewLanjutanViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/01/25.
//

import UIKit

class CollectionViewLanjutanViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let sections = [
        ["Item 1", "Item 2", "Item 3"], // Section 1
        ["Item A", "Item B"],           // Section 2
        ["Item X", "Item Y", "Item Z"]  // Section 3
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set custom layout
        let layout = CustomGridLayout()
        collectionView.collectionViewLayout = layout
        
        collectionView.dataSource = self
        collectionView.delegate = self
        // **Registrasi Cell & Header**
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.register(MyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }
    
}

extension CollectionViewLanjutanViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout   {
    // Jumlah section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    // Jumlah item per section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    // Tampilan cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCollectionViewCell
        cell.titleLabel.text = sections[indexPath.section][indexPath.row]
        return cell
    }
    
    // Header untuk setiap section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! MyHeaderView
            header.titleLabel.text = "Section \(indexPath.section + 1)"
            return header
        }
        return UICollectionReusableView()
    }
    
    // Ukuran header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

