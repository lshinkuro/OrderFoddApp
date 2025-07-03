//
//  ShoeUseCase.swift
//  OrderFoodApp
//
//  Created by Phincon on 13/03/25.
//

import RxSwift

protocol ShoeUseCaseProtocol {
    func fetchShoeItems() -> Observable<[ShoeItem]>
}

class ShoeUseCase: ShoeUseCaseProtocol {
  
    
    private let repository: ShoeRepositoryProtocol
    
    init(repository: ShoeRepositoryProtocol = ShoeRepository()) {
        self.repository = repository
    }
    
    func fetchShoeItems() -> Observable<[ShoeItem]> {
        return repository.getShoeItems()
    }
    
  
}
