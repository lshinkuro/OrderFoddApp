//
//  ShoeListViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 21/01/25.
//

import Foundation
import RxSwift
import RxCocoa

class ShoeListViewModel: BaseViewModel {
    
    private let service: ShoeUseCaseProtocol
    
    var onStateChange: ((DataState) -> Void)?
    
    // Output
    let shoeItems = BehaviorRelay<[ShoeItem]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = PublishRelay<String>()
    
    init(useCase service: ShoeUseCase = ShoeUseCase()) {
        self.service = service
    }
    
    func fetchShoeItems() {
        isLoading.accept(true)
        onStateChange?(.loading)
        
        service.fetchShoeItems()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] items in
                    guard let self = self else { return }
                    self.isLoading.accept(false)
                    self.shoeItems.accept(items)
                    
                    if items.isEmpty {
                        self.onStateChange?(.empty)
                    } else {
                        self.onStateChange?(.success)
                    }
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.isLoading.accept(false)
                    self.errorMessage.accept(error.localizedDescription)
                    self.onStateChange?(.error(error.localizedDescription))
                }
            )
            .disposed(by: bag)
    }
    
    func toggleFavorite(for index: Int) {
        var updatedItems = shoeItems.value
        updatedItems[index].isFavorite.toggle()
        shoeItems.accept(updatedItems)
        onStateChange?(.success)
    }
}
