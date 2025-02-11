//
//  ShoeListViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 21/01/25.
//

import Foundation

// Menggunakan mekanisme binding dengan Closure
class ShoeListViewModel {
    
    private let service: ShoeService
    
    var onStateChange: ((DataState) -> Void)?
    
    private(set) var shoeItems: [ShoeItem] = []
    
    init(service: ShoeService = ShoeService()) {
        self.service = service
    }
    
    
    func fetchShoeItems() {
        onStateChange?(.loading)
        service.fetchShoeItems { [weak self] result in
           guard let self = self else { return }
           DispatchQueue.main.async {
               switch result {
               case .success(let items):
                   self.shoeItems = items
                   if items.isEmpty {
                       self.onStateChange?(.empty)
                   } else {
                       self.onStateChange?(.success)
                   }
               case .failure(let error):
                   self.onStateChange?(.error(error.localizedDescription))
               }
           }
        }
    }
    
    func toggleFavorite(for index: Int) {
        shoeItems[index].isFavorite.toggle()
        self.onStateChange?(.success)
    }
}

