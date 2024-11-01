//
//  DashboardViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 04/10/24.
//

import Foundation
import RxSwift
import RxRelay

class DashboardViewModel: BaseViewModel {
    
    private let manager = ThreadManager.shared
    
    var foodsModel = BehaviorRelay<FoodModel?>(value: nil)
    let appService = APIManager.shared
        
    override init() {}
    
    public func fetchAllMenu() {
        loadingState.accept(.loading)
        appService.fetchRequest(endpoint: .getAllMenu, expecting: FoodModel.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.foodsModel.accept(data)
     
            case .failure(_):
                self.loadingState.accept(.failed)
            }
        }
    }
}
