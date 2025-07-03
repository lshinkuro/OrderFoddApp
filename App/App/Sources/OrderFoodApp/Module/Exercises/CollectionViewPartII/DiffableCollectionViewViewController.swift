//
//  DiffableCollectionViewViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 31/01/25.
//

import UIKit

class DiffableCollectionViewViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // Diffable Data Source
    private var dataSource: UICollectionViewDiffableDataSource<SectionBook, Book>!
    
    // Data
    private var books: [Book] = [
        Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", coverImageName: "great_gatsby"),
        Book(title: "1984", author: "George Orwell", coverImageName: "1984"),
        Book(title: "To Kill a Mockingbird", author: "Harper Lee", coverImageName: "mockingbird"),
        Book(title: "Pride and Prejudice", author: "Jane Austen", coverImageName: "pride_prejudice"),
        Book(title: "The Catcher in the Rye", author: "J.D. Salinger", coverImageName: "catcher_rye")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureDataSource()
        applyInitialSnapshot()

    }

    private func setupCollectionView() {
        // Set layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        collectionView.collectionViewLayout = layout
        
        // Register custom cell
        collectionView.register(BookCollectionCell.self, forCellWithReuseIdentifier: BookCollectionCell.identifier)
    }

    
    private func addNewBook() {
        let newBook = Book(title: "Moby Dick", author: "Herman Melville", coverImageName: "moby_dick")
        books.append(newBook)
        
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([newBook])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func deleteBook(at indexPath: IndexPath) {
        guard let book = dataSource.itemIdentifier(for: indexPath) else { return }
        books.removeAll { $0 == book }
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([book])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}


extension DiffableCollectionViewViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionBook, Book>(collectionView: collectionView) { collectionView, indexPath, book in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionCell.identifier, for: indexPath) as! BookCollectionCell
            cell.configure(with: book)
            return cell
        }
    }
}

extension DiffableCollectionViewViewController {
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionBook, Book>()
        snapshot.appendSections([.main])
        snapshot.appendItems(books)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

