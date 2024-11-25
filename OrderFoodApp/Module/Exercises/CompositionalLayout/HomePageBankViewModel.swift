//
//  HomePageBankViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/11/24.
//
import RxSwift
import RxRelay

class HomePageBankViewModel: BaseViewModel{
    
    var bankData = BehaviorRelay<BankingData?>(value: nil)
    let appService = NetworkManager.shared
        
    override init() {}
    
    public func getData() {
        loadingState.accept(.loading)
        appService.fetchRequest(endpoint: .getDataBank, expecting: BankingData.self) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.bankData.accept(data)
     
            case .failure(let err):
                print("error: \(err)")
                self.loadingState.accept(.failed)
            }
        }
    }
}



