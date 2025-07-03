//
//  DragDropCollectionViewViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/01/25.
//


import UIKit

class DragDropCollectionViewViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Data untuk collection view
    var items: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        // Set layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
        
        // Register cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        // Set data source dan delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Enable drag and drop
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
    }
}

extension DragDropCollectionViewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        
        // Hapus subview sebelumnya (jika ada)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Tambahkan label ke cell
        let label = UILabel(frame: cell.bounds)
        label.text = items[indexPath.item]
        label.textAlignment = .center
        label.textColor = .white
        cell.contentView.addSubview(label)
        
        return cell
    }
}

extension DragDropCollectionViewViewController: UICollectionViewDragDelegate {
    // Method ini dipanggil saat drag dimulai
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = items[indexPath.item]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}


extension DragDropCollectionViewViewController: UICollectionViewDropDelegate {
    // Method ini dipanggil saat item di-drop
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            // Jika ada index path tujuan, gunakan itu
            destinationIndexPath = indexPath
        } else {
            // Jika tidak, gunakan index path terakhir
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        // Proses drop
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                // Jika item dipindahkan dalam collection view yang sama
                collectionView.performBatchUpdates({
                    let movedItem = items.remove(at: sourceIndexPath.item)
                    items.insert(movedItem, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
    // Method ini dipanggil untuk menentukan apakah drop diperbolehkan
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
