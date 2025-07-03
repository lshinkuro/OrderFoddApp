//
//  CustomLayoutGrid.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/01/25.
//

import UIKit

class CustomGridLayout: UICollectionViewLayout {
    
    
    // Cache untuk menyimpan atribut layout
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // Tinggi total konten
    private var contentHeight: CGFloat = 0
    
    // Lebar total konten
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }
    
    // Ukuran total konten
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    
    // Menghitung dan menyimpan atribut layout
    /*override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        // Lebar setiap kolom
        let columnWidth = contentWidth / 3
        
        // Array untuk menyimpan offset X (horizontal) setiap kolom
        var xOffset: [CGFloat] = []
        for column in 0..<3 {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        // Array untuk menyimpan offset Y (vertikal) setiap kolom
        var yOffset = [CGFloat](repeating: 0, count: 3)
        
        // Loop melalui semua item
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // Tentukan kolom dengan offset Y terkecil
            let column = yOffset[0] < yOffset[1] ? (yOffset[0] < yOffset[2] ? 0 : 2) : (yOffset[1] < yOffset[2] ? 1 : 2)
            
            // Hitung frame untuk item
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: columnWidth)
            
            // Buat atribut layout
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            
            // Simpan atribut ke cache
            cache.append(attributes)
            
            // Update offset Y untuk kolom yang dipilih
            yOffset[column] = yOffset[column] + columnWidth
        }
        
        // Hitung tinggi total konten
        contentHeight = yOffset.max() ?? 0
    }*/
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let centerX = collectionView.bounds.width / 2
        let centerY = collectionView.bounds.height / 2
        let radius: CGFloat = 100
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let angle = 2 * CGFloat.pi * CGFloat(item) / CGFloat(collectionView.numberOfItems(inSection: 0))
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: x, y: y, width: 50, height: 50)
            cache.append(attributes)
        }
    }
    
    // Mengembalikan atribut layout untuk semua item yang terlihat
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    // Mengembalikan atribut layout untuk item tertentu
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
