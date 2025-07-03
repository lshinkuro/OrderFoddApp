//
//  ShoeRepository.swift
//  OrderFoodApp
//
//  Created by Phincon on 13/03/25.
//

import RxSwift

protocol ShoeRepositoryProtocol {
    func getShoeItems() -> Observable<[ShoeItem]>
}

class ShoeRepository: ShoeRepositoryProtocol {
    private let apiService: ShoeServiceProtocol
    
    init(apiService: ShoeServiceProtocol = ShoeService()) {
        self.apiService = apiService
    }
    
    func getShoeItems() -> Observable<[ShoeItem]> {
        return apiService.fetchShoeItems()
    }
}

