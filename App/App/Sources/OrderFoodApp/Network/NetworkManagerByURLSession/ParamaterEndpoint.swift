//
//  ParamaterEndpoint.swift
//  OrderFoodApp
//
//  Created by Phincon on 16/10/24.
//

import Foundation


struct LoginParam {
    let username: String
    let password: String
}

struct RegisterParam {
    let email: String
    let fullname: String
    let username: String
    let password: String
    let phoneNumber: String
}

/*{
 "email": "kholis@gmail.com",
 "fullname": "Joni Cage",
 "password": "Qwerty123!",
 "phoneNumber": "085775380162",
 "username": "joniCage"
}*/


struct CreateOrderParam {
    let email: String
    let items: [OrderItem]
    let amount: Int
}

struct OrderItem {
    let id: Int
    let name: String
    let price: Int
    let quantity: Int
}
