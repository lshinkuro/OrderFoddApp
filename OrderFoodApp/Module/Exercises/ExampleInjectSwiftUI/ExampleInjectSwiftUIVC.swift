//
//  ExampleInjectSwiftUIVC.swift
//  OrderFoodApp
//
//  Created by Phincon on 06/02/25.
//

import Foundation
import UIKit
import SwiftUI

class ItemTableViewCell: BaseHostingTableViewCell<SwiftUICellViewV2> {
    
    static let identifier = "ItemTableViewCell"
    
    func configure(with data: Book, parentViewController: UIViewController, onButtonTap: @escaping () -> Void) {
        let swiftUIView = SwiftUICellViewV2(title: data.title, subtitle: data.author,imageUrl: data.coverImageName, onButtonTap: onButtonTap)
        super.configure(with: swiftUIView, parentViewController: parentViewController)
    }
}


class ExampleInjectSwiftUIVC: UIViewController {
    
    private let tableView = UITableView()
    private var books: [Book] = [
        Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", coverImageName: "great_gatsby"),
        Book(title: "1984", author: "George Orwell", coverImageName: "1984"),
        Book(title: "To Kill a Mockingbird", author: "Harper Lee", coverImageName: "mockingbird"),
        Book(title: "Pride and Prejudice", author: "Jane Austen", coverImageName: "pride_prejudice"),
        Book(title: "The Catcher in the Rye", author: "J.D. Salinger", coverImageName: "catcher_rye")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    
}

extension ExampleInjectSwiftUIVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: books[indexPath.row], parentViewController: self) { [weak self] in
            guard let self = self else {return}
            self.showAlert(for: self.books[indexPath.row].title)
        }
     
        return cell
    }
    
    private func showAlert(for title: String) {
        let alert = UIAlertController(title: "Info", message: "Detail tentang \(title)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

