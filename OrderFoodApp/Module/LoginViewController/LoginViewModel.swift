//
//  LoginViewModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 16/10/24.
//

import Foundation


class LoginViewModel {
    
    let networkManager = NetworkManager.shared

    var onLoading:  ((_ loading: StateLoading?) -> Void)?
    var onUpdateItem: ((_ data: LoginResponseModel?) -> Void)?
    var onError: ((_ data: Error?) -> Void)?


    func requestData(param: LoginParam) {
        self.onLoading?(.loading)
        NetworkManager.shared.fetchRequest(endpoint: .login(param: param), expecting: LoginResponseModel.self) { result in
            switch result {
            case .success(let data):
                print("login berhasil: \(data)")
                self.onLoading?(.finished)
                self.onUpdateItem?(data)
            case .failure(let error):
                print("Terjadi error: \(error)")
                self.onError?(error)
                self.onLoading?(.failed)
            }
        }
    }
    
}
