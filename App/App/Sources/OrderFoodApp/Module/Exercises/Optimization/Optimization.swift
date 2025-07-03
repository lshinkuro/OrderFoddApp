//
//  Optimization.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/01/25.
//

import Foundation
import UIKit
import CoreData



class Optimization {
    
    let imageView: UIImageView = UIImageView()
    
    let tableView: UITableView = UITableView()

    var currentPage = 1
    var items: [String] = []

    
    // MARK: Optimasi For Image Reduce
    func imageReduce() {
        if let image = UIImage(named: "example") {
            let compressedData = image.jpegData(compressionQuality: 0.5) // Kompres gambar
            let compressedImage = UIImage(data: compressedData!)
            imageView.image = compressedImage
        }
    }
    
    
    
    // MARK: Optimasi For Pagination
    func fetchPaginatedData(page: Int, completion: @escaping ([String]) -> Void) {
        let url = URL(string: "https://api.example.com/items?page=\(page)")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let items = try? JSONDecoder().decode([String].self, from: data) {
                completion(items)
            }
        }.resume()
    }
    
    func testPagination() {
        // Contoh penggunaan
        fetchPaginatedData(page: currentPage) { [weak self] newItems in
            guard let self = self else { return }
            self.items.append(contentsOf: newItems)
            self.currentPage += 1
            self.tableView.reloadData()
        }
    }
    

    func saveToCoreData(entityName: String, data: [String: Any]) {
        let context = CoreDataManager.shared.context
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        
        data.forEach { entity.setValue($1, forKey: $0) }
        
        do {
            try context.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    let imageCache = NSCache<NSString, UIImage>()

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                completion(image)
            }
        }.resume()
    }
    
    
    // Hindari menyimpan kode yang tidak relevan atau tidak dipanggil
    func unusedFunction() {
        print("This function is never called")
    }


   
}
