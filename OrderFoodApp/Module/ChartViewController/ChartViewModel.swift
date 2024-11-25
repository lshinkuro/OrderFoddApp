//
//  ChartViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 11/11/24.
//

import Foundation
import RxSwift
import RxRelay

class ChartViewModel: BaseViewModel{
    
    var orderModel = BehaviorRelay<OrderDataModel?>(value: nil)
    let appService = NetworkManager.shared
        
    override init() {}
    
    public func createOrder(param: CreateOrderParam) {
        loadingState.accept(.loading)
        appService.fetchRequest(endpoint: .createOrder(param: param), expecting: OrderModel.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.orderModel.accept(data.data)
     
            case .failure(let err):
                print("error: \(err)")
                self.loadingState.accept(.failed)
            }
        }
    }
}
