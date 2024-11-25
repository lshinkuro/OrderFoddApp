//
//  URLSessionViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 14/10/24.
//

import Foundation
import RxSwift
import RxRelay

class URLSessionViewModel: BaseViewModel {
    
    let networkManager = NetworkManager.shared
    let appService = NetworkManager.shared


    var onLoading:  ((_ loading: StateLoading?) -> Void)?
    var onUpdateItem: ((_ data: [PlaceholderItem]?) -> Void)?
    var onError: ((_ data: Error?) -> Void)?
    
    let placeholderData = BehaviorRelay<[PlaceholderItem]?>(value: nil)
    let errorData = BehaviorRelay<Error?>(value: nil)

    
    var onUpdateFoodItem: ((_ data: FoodCategoryItem?) -> Void)?

    func requestData(url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func fetchRequest() {
        Task {
            do {
                if let url = URL(string: "https://jsonplaceholder.typicode.com/posts") {
                    let result = try await requestData(url: url)
                    
                    print("data berhasil di dapat \(result)")
                    
                    // Decode JSON data menjadi struct Todo
                    let todo = try JSONDecoder().decode([PlaceholderItem].self, from: result)
                    self.onUpdateItem?(todo)
                }
            } catch let e {
                print("error \(e)")
            }
        }
        
    }
    
    func requestData() {
        self.onLoading?(.loading)
        NetworkManager.shared.fetchRequest(endpoint: .posts, expecting: [PlaceholderItem].self) { result in
            switch result {
            case .success(let data):
                print("Items berhasil diambil: \(data)")
                self.onLoading?(.finished)
                self.onUpdateItem?(data)
            case .failure(let error):
                print("Terjadi error: \(error)")
                self.onError?(error)
                self.onLoading?(.failed)
            }
        }
    }
    
    
    func requestCategoryFood(type: String) {
        self.onLoading?(.loading)
        NetworkManager.shared.fetchRequest(endpoint: .getByCategory(type: type), expecting: FoodCategoryItem.self) { result in
            switch result {
            case .success(let data):
                print("Items berhasil diambil: \(data)")
                self.onLoading?(.finished)
                self.onUpdateFoodItem?(data)
            case .failure(let error):
                print("Terjadi error: \(error)")
                self.onError?(error)
                self.onLoading?(.failed)
            }
        }
    }
  
    
}
